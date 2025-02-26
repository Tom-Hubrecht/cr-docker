{
  dockerTools,

  # Packages included in the closure
  bash,
  gappa,
  sollya,
}:

dockerTools.buildLayeredImage {
  name = "cr-workspace";

  contents = [
    bash
    gappa
    sollya
  ];

  config = {
    Cmd = [ "bash" ];
  };
}
