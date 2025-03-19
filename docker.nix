{
  dockerTools,

  # Packages included in the closure
  bashInteractive,
  coreutils,
  gappa,
  rlwrap,
  sollya,
}:

dockerTools.buildLayeredImage {
  name = "cr-workspace";

  contents = [
    bashInteractive
    coreutils
    gappa
    rlwrap
    sollya
  ];

  config = {
    Cmd = [ "bash" ];
    Env = [
      "HOME=/data"
    ];
    Volumes = {
      "/data" = { };
    };
    WorkingDir = "/data";
  };
}
