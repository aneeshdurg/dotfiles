#!/usr/bin/env python3
"""Simple dev-time fileserver: serves the tree rooted at --root (default: cwd)
over HTTP, read-only. Directories render a sortable, fuzzy-searchable listing;
files are served directly."""
import argparse
import grp
import os
import pwd
import stat
from datetime import datetime

from flask import Flask, abort, render_template, send_from_directory
from werkzeug.security import safe_join

app = Flask(__name__)
ROOT = os.getcwd()


def human_size(n):
    for unit in ["B", "K", "M", "G", "T", "P"]:
        if n < 1024 or unit == "P":
            return f"{n:.0f}{unit}" if unit == "B" else f"{n:.1f}{unit}"
        n /= 1024


def safe_resolve(rel_path):
    joined = safe_join(ROOT, rel_path) if rel_path else ROOT
    if joined is None:
        abort(404)
    return joined


def list_dir(fs_path, url_path):
    entries = []
    with os.scandir(fs_path) as it:
        for de in it:
            try:
                st = de.stat(follow_symlinks=False)
            except OSError:
                continue
            is_dir = de.is_dir(follow_symlinks=True)
            symlink_target = os.readlink(de.path) if de.is_symlink() else None
            try:
                owner = pwd.getpwuid(st.st_uid).pw_name
            except KeyError:
                owner = str(st.st_uid)
            try:
                group = grp.getgrgid(st.st_gid).gr_name
            except KeyError:
                group = str(st.st_gid)
            href = url_path.rstrip("/") + "/" + de.name
            entries.append({
                "name": de.name,
                "is_dir": is_dir,
                "symlink_target": symlink_target,
                "size": st.st_size,
                "size_human": "-" if is_dir else human_size(st.st_size),
                "perm": stat.filemode(st.st_mode),
                "owner": owner,
                "group": group,
                "mtime": int(st.st_mtime),
                "mtime_human": datetime.fromtimestamp(st.st_mtime).strftime("%Y-%m-%d %H:%M"),
                "href": href,
            })
    entries.sort(key=lambda e: (not e["is_dir"], e["name"].lower()))
    return entries


@app.route("/", defaults={"req_path": ""})
@app.route("/<path:req_path>")
def serve(req_path):
    fs_path = safe_resolve(req_path)
    if not os.path.exists(fs_path):
        abort(404)

    if os.path.isdir(fs_path):
        url_path = "/" + req_path
        segments = [s for s in req_path.split("/") if s]
        breadcrumbs = [("~", "/")]
        acc = ""
        for seg in segments:
            acc += "/" + seg
            breadcrumbs.append((seg, acc))
        parent_href = "/" + "/".join(segments[:-1])
        return render_template(
            "listing.html",
            title=url_path,
            breadcrumbs=breadcrumbs,
            is_root=(req_path == ""),
            parent_href=parent_href,
            entries=list_dir(fs_path, url_path),
        )

    directory, filename = os.path.split(fs_path)
    return send_from_directory(directory, filename)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-p", "--port", type=int, default=8000, help="port to listen on (default: 8000)")
    parser.add_argument("--host", default="0.0.0.0", help="host/interface to bind (default: 0.0.0.0)")
    parser.add_argument("--root", default=os.getcwd(), help="directory to serve (default: cwd)")
    args = parser.parse_args()

    global ROOT
    ROOT = os.path.realpath(args.root)

    app.run(host=args.host, port=args.port, debug=False)


if __name__ == "__main__":
    main()
