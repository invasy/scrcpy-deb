# scrcpy Ubuntu package

> This application provides display and control
> of Android devices connected on USB (or over TCP/IP).
> It does not require any root access.
> It works on GNU/Linux, Windows and macOS.

## How to make package

```bash
make [deb]
```

### What `make` does

- clone `scrcpy` repository
- add [SystemD service file](https://github.com/invasy/scrcpy-deb/blob/master/scrcpy.service)
- configure and build `scrcpy`

## Links

- [Genymobile/scrcpy](https://github.com/Genymobile/scrcpy/)
- [Debian Policy Manual](https://www.debian.org/doc/debian-policy/)
