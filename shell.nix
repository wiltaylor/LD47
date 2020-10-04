{ pkgs ? import <nixpkgs> {} }:

  pkgs.mkShell {
    buildInputs = [ pkgs.gimp pkgs.ardour pkgs.godot pkgs.krita pkgs.aseprite pkgs.audacity pkgs.imagemagick pkgs.emscripten ];

    shellHook = ''


    '';
}
