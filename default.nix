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

  nix-reuse = import sources.nix-reuse { inherit pkgs; };
  nix-actions = import sources.nix-actions { inherit pkgs; };

  callFunctionWith =
    autoArgs: fn:
    let
      f = if builtins.isFunction fn then fn else import fn;
    in
    f (builtins.intersectAttrs (builtins.functionArgs f) autoArgs);

  call = callFunctionWith (pkgs // tools);

  reuse = nix-reuse.install {
    defaultLicense = "MIT";
    defaultCopyright = "Tom Hubrecht <tom.hubrecht@ens-lyon.fr>";

    installPath = builtins.toString ./.;

    # downloadLicenses = true;
    generatedPaths = [
      ".envrc"
      ".gitignore"
      "shell.nix"
    ];

    annotations = [
      { path = ".github/workflows/*"; }
    ];
  };

  workflows = nix-actions.install {
    src = ./.;
    buildCheck = false;

    platform = "github";

    workflows = {
      build-docker = {
        name = "Build the docker image";
        on.push.brnaches = [ "main" ];

        jobs.build = {
          runs-on = "ubuntu-latest";
          steps = [
            { uses = "actions/checkout@v4"; }
            { uses = "samueldr/lix-gha-installer-action@v2025-01-24.prerelease"; }
            { run = "nix-build -A dockerFile"; }
          ];
        };
      };
    };
  };
in

{
  dockerFile = call ./docker.nix;

  devShell = pkgs.mkShell {
    name = "cr-docker.dev";

    packages = [
      pkgs.podman
    ];

    shellHook = builtins.concatStringsSep "\n" [
      reuse.shellHook
      workflows.shellHook
    ];
  };
}
