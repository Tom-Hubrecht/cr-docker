# SPDX-FileCopyrightText: 2024 Tom Hubrecht <tom.hubrecht@dgnum.eu>
#
# SPDX-License-Identifier: EUPL-1.2

{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:

let
  inherit (pkgs.lib)
    genAttrs
    ;

  tools = genAttrs [ "gappa" ] (pname: pkgs.callPackage ./tools/${pname}.nix { });

  callFunctionWith =
    autoArgs: fn:
    let
      f = if builtins.isFunction fn then fn else import fn;
    in
    f (builtins.intersectAttrs (builtins.functionArgs f) autoArgs);

  call = callFunctionWith (pkgs // tools);
in

{
  dockerFile = call ./docker.nix;

  devShell = pkgs.mkShell {
    name = "cr-docker.dev";

    packages = [
      pkgs.podman
    ];
  };
}
