#! /usr/bin/env python3

import argparse as ap


def main():
    parser = ap.ArgumentParser(description="This is a wallpaper script")
    parser.add_argument("name", help="This is the name of the wallpaper")
    args = parser.parse_args()
    # check for file name extension if its png or jpg
    print(f"img:/home/btngana/Pictures/{args.name}:text:{args.name}")


if __name__ == "__main__":

    main()
