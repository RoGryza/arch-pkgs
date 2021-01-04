# From https://gitlab.com/rycee/nur-expressions
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.me.themes;

  inherit (builtins) abort foldl' listToAttrs substring toJSON;
  inherit (lib.attrsets) mapAttrs mapAttrs' mapAttrsToList;
  inherit (lib.lists) findSingle;
  inherit (lib.strings) concatStringsSep stringToCharacters;

  fromHex = let
    hexes = {
      "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
      "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
      "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
    };
  in v: foldl' (acc: x: acc * 16 + hexes.${x}) 0 (stringToCharacters v);

  mkColorComponentOption = component: mkOption {
    type = types.strMatching "[0-9a-fA-F]{2}";
    visible = false;
    description = "The ${component} component value as a hexadecimal string.";
  };

  mkDecColorOption = component: mkOption {
    type = types.ints.u8;
    visible = false;
    readOnly = true;
    description = "The ${component} component value as a decimal number.";
  };

  colorType = types.strMatching "[0-9a-fA-F]{6}";
  schemeAttrs = scheme:
    let
      colors = flip mapAttrs' scheme
        (name: hex: {
          name = "${substring 4 6 name}";
          value = rec {
            inherit hex;
            red = substring 0 2 hex;
            green = substring 2 4 hex;
            blue = substring 4 6 hex;
            red-rgb = fromHex hex;
            green-rgb = fromHex hex;
            blue-rgb = fromHex hex;
          };
        });
      rest = foldl'
        (acc: x: acc // x) {}
        (flip mapAttrsToList colors
          (name: col: {
            "base${name}-hex" = col.hex;
            "base${name}-hex-r" = col.red;
            "base${name}-hex-g" = col.green;
            "base${name}-hex-b" = col.blue;

            "base${name}-rgb-r" = col.red-rgb;
            "base${name}-rgb-g" = col.green-rgb;
            "base${name}-rgb-b" = col.blue-rgb;

            "base${name}-dec-r" = col.red-rgb;
            "base${name}-dec-g" = col.green-rgb;
            "base${name}-dec-b" = col.blue-rgb;
          }));
    in { inherit colors; } // rest;
in
{
  options.me.themes = {
    schemes = mkOption {
      type = with types; addCheck (attrsOf (submodule {
        options = {
          base00 = mkOption { type = colorType; };
          base01 = mkOption { type = colorType; };
          base02 = mkOption { type = colorType; };
          base03 = mkOption { type = colorType; };
          base04 = mkOption { type = colorType; };
          base05 = mkOption { type = colorType; };
          base06 = mkOption { type = colorType; };
          base07 = mkOption { type = colorType; };
          base08 = mkOption { type = colorType; };
          base09 = mkOption { type = colorType; };
          base0A = mkOption { type = colorType; };
          base0B = mkOption { type = colorType; };
          base0C = mkOption { type = colorType; };
          base0D = mkOption { type = colorType; };
          base0E = mkOption { type = colorType; };
          base0F = mkOption { type = colorType; };
        };
      })) (x: x != {});
    };

    defaultScheme = mkOption { type = types.str; };
  };

  config = {
    lib.base16.template = scheme: attrs@{name, src, slug, ...}:
      pkgs.stdenv.mkDerivation {
        inherit name;
        inherit src;
        data = pkgs.writeText "${name}-data" (
          toJSON ((schemeAttrs scheme) // { scheme-slug = slug; })
        );
        phases = [ "buildPhase" ];
        buildPhase = "${pkgs.mustache-go}/bin/mustache $data $src > $out";
        allowSubstitutes = false;
      };

      lib.base16.templates = { app, template, install, installPhase ? "" }:
        pkgs.stdenv.mkDerivation {
          name = "${app}-base16";
          phases = [ "installPhase" ];
          preferLocalBuild = true;
          installPhase =
            let
              instantiate = name: scheme: config.lib.base16.template scheme {
                name = "${app}-base16-${name}";
                slug = name;
                src = template;
              };
            in ''
              ${installPhase}
              ${concatStringsSep "\n"
                (mapAttrsToList
                  (name: scheme: install name (instantiate name scheme))
                  cfg.schemes)}
            '';
        };
  };
}
