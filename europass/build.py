#!/usr/bin/env python3
"""Render europass/cv.xml to final-pdfs/europass-cv.pdf via europass.europa.eu.

Why this is hybrid (auto-login + manual upload/export):
  The Europass post-2020 SPA changes its selectors regularly and there is no
  longer a public REST API. Hard-coding selectors for "Import" / "Export PDF"
  rots fast. Instead, this script automates the stable parts (XML validation,
  EU Login, persistent session, PDF download capture) and pauses for the human
  to drive the two UI clicks that change.

Env:
  EUROPASS_EMAIL, EUROPASS_PASSWORD  EU Login credentials (required).
  EUROPASS_HEADLESS=1                Force headless once selectors are stable.
  EUROPASS_KEEP_OPEN=1               Don't close the browser at the end.
"""

import os
import subprocess
import sys
from pathlib import Path

from playwright.sync_api import (
    Page,
    TimeoutError as PlaywrightTimeoutError,
    sync_playwright,
)

REPO = Path(__file__).resolve().parent.parent
_CV_DATA = Path(os.environ.get("CV_DATA_DIR", str(REPO / "data.example")))
XML = _CV_DATA / "europass" / "cv.xml"
XSD = REPO / "europass" / "schema" / "v3.4.0" / "EuropassSchema.xsd"
OUT_PDF = _CV_DATA / "final-pdfs" / "europass-cv.pdf"
PROFILE = Path.home() / ".cache" / "CV-nixCfg" / "europass-chromium"

EUROPASS_HOME = "https://europass.europa.eu/en"
EUROPASS_MY = "https://europass.europa.eu/en/my-europass"


def fail(msg: str, code: int = 1) -> "NoReturn":
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(code)


def need_env(name: str) -> str:
    v = os.environ.get(name)
    if not v:
        fail(f"{name} is not set", code=2)
    return v


def validate_xml() -> None:
    if not XML.exists():
        fail(f"missing {XML}")
    if not XSD.exists():
        fail(f"missing {XSD}")
    print(f"-> validating {XML.relative_to(REPO)} against vendored XSD")
    subprocess.run(
        ["xmllint", "--noout", "--schema", str(XSD), str(XML)],
        check=True,
    )


def dismiss_cookie_banner(page: Page) -> None:
    for name in ("Accept all cookies", "I accept", "Accept all"):
        try:
            page.get_by_role("button", name=name).click(timeout=3000)
            print(f"   dismissed cookie banner ('{name}')")
            return
        except PlaywrightTimeoutError:
            continue


def try_login(page: Page, email: str, password: str) -> None:
    # If a persistent profile already has a session, the Login link won't appear.
    try:
        page.get_by_role("link", name="Login", exact=False).first.click(timeout=4000)
    except PlaywrightTimeoutError:
        print("   no Login link found; assuming session is active")
        return

    try:
        page.wait_for_url("**/cas/**", timeout=15000)
    except PlaywrightTimeoutError:
        print("   no EU Login redirect; continuing")
        return

    print("-> EU Login: filling credentials")
    for sel in ('input[name="email"]', 'input[type="email"]', "#email"):
        if page.locator(sel).count():
            page.fill(sel, email)
            break
    page.locator('input[type="submit"], button[type="submit"]').first.click()

    page.wait_for_selector('input[type="password"]', timeout=20000)
    page.fill('input[type="password"]', password)
    page.locator('input[type="submit"], button[type="submit"]').first.click()

    try:
        page.wait_for_url("**europass.europa.eu/**", timeout=60000)
        print("   login succeeded")
    except PlaywrightTimeoutError:
        fail(
            "login did not return to europass.europa.eu within 60s — check MFA/CAPTCHA in the browser"
        )


def manual_step(prompt: str) -> None:
    print(f"\n  -> manual step needed: {prompt}")
    print("     interact with the browser, then press Enter here to continue.")
    try:
        input()
    except (EOFError, KeyboardInterrupt):
        fail("interrupted by user")


def main() -> None:
    validate_xml()
    email = need_env("EUROPASS_EMAIL")
    password = need_env("EUROPASS_PASSWORD")
    headless = os.environ.get("EUROPASS_HEADLESS") == "1"
    keep_open = os.environ.get("EUROPASS_KEEP_OPEN") == "1"

    OUT_PDF.parent.mkdir(parents=True, exist_ok=True)
    PROFILE.mkdir(parents=True, exist_ok=True)

    with sync_playwright() as p:
        ctx = p.chromium.launch_persistent_context(
            user_data_dir=str(PROFILE),
            headless=headless,
            accept_downloads=True,
            viewport={"width": 1440, "height": 900},
            locale="en-GB",
        )
        page = ctx.pages[0] if ctx.pages else ctx.new_page()

        print(f"-> opening {EUROPASS_HOME}")
        page.goto(EUROPASS_HOME, wait_until="domcontentloaded")
        dismiss_cookie_banner(page)
        try_login(page, email, password)

        page.goto(EUROPASS_MY, wait_until="domcontentloaded")
        manual_step(
            f"upload {XML.relative_to(REPO)} via 'Import' or 'Upload XML' on the profile page"
        )

        with page.expect_download(timeout=300_000) as download_info:
            manual_step("trigger 'Download CV as PDF' / 'Export PDF'")
        download = download_info.value
        download.save_as(str(OUT_PDF))
        print(
            f"\n-> wrote {OUT_PDF.relative_to(REPO)} ({OUT_PDF.stat().st_size} bytes)"
        )

        if not keep_open:
            ctx.close()


if __name__ == "__main__":
    main()
