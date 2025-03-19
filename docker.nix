{
  dockerTools,

  # Packages included in the closure
  bash,
  gappa,
  rlwrap,
  sollya,
}:

dockerTools.buildLayeredImage {
  name = "cr-workspace";

  contents = [
    bash
    gappa
    rlwrap
    sollya
  ];

  config = {
    Cmd = [ "bash" ];
  };
}
