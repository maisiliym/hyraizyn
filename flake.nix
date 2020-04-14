{
  description = "hyraizyn";

  outputs = { self, kor, lib, metastriz, steit }@fleiks:
    let
      meik = { astraNeim, metastraNeim, metastriz ? fleiks.metastriz.datom }:
        let
          lib = fleiks.lib.datom;
          inherit (lib) evalModules;

          mkSpicizModule = import ./mkSpicizModule.nix;
          metastrizOptions = import ./metastrizOptions.nix;
          hyraizynOptions = import ./hyraizynOptions.nix;
          mkHyraizynModule = import ./mkHyraizynModule.nix;

          argzModule = {
            config = {
              inherit metastriz astraNeim metastraNeim;
              _module.args = {
                inherit kor lib;
              };
            };
          };

          ivaliueicyn = evalModules {
            modules = [
              argzModule
              mkSpicizModule
              metastrizOptions
              hyraizynOptions
              mkHyraizynModule
            ];
          };

        in
        ivaliueicyn.config.hyraizyn;

      datom = meik { inherit (steit.datom) astraNeim metastraNeim; };

      krimyn = datom.${steit.datom.krimynNeim};

    in
    { inherit meik datom krimyn; };
}
