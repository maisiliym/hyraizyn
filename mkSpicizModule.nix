{ kor, lib, config, ... }:
let
  inherit (builtins) attrNames attrValues;
  inherit (kor) arkSistymMap;
  inherit (lib) mkOption;
  inherit (lib.types) enum str attrsOf submodule nullOr bool int
    listOf attrs;
  inherit (config) metastriz metastraNeim;

  magnytiud = [ 0 1 2 3 ];

  mycinArkz = attrNames arkSistymMap;
  sistymz = attrValues arkSistymMap;

  butlodyrz = [ "uefi" "mbr" "uboot" ];
  kibordz = [ "qwerty" "colemak" ];

  astriSpiciz = [ "sentyr" "haibrid" "edj" ];

  metastriNeimz = attrNames metastriz;
  astriNeimz = attrNames metastriz.${metastraNeim}.astriz;

  krimynNeimz = attrNames metastriz.${metastraNeim}.krimynz;

  priKriomSubmodule = {
    options = {
      eseseitc = mkOption {
        type = str;
      };

      keygrip = mkOption {
        type = str;
      };
    };
  };

  komynKrimynOptions = {
    saiz = mkOption {
      type = enum magnytiud;
      default = 0;
    };

    spici = mkOption {
      type = enum [ "Uniks" "Sema" "Onlimityd" ];
      default = "Sema";
    };

    priKriomz = mkOption {
      type = attrsOf (submodule priKriomSubmodule);
    };

    kibord = mkOption {
      type = enum [ "colemak" "qwerty" ];
      default = "colemak";
    };

  };

  mycinSpici = submodule {
    options = {
      spici = mkOption {
        type = enum [ "metyl" "pod" ];
        default = "metyl";
      };

      ark = mkOption {
        type = nullOr (enum mycinArkz);
        default = null;
      };

      modyl = mkOption {
        type = nullOr str;
        default = null;
      };

      mothyrBord = mkOption {
        type = nullOr (enum mothyrBordSpiciNeimz);
        default = null;
      };

      ubyrAstri = mkOption {
        type = nullOr (enum astriNeimz);
        default = null;
      };

      ubyrKrimyn = mkOption {
        type = nullOr (enum krimynNeimz);
        default = null;
      };
    };
  };

  IoOptions = {
    kibord = mkOption {
      type = enum kibordz;
      default = "colemak";
    };

    butlodyr = mkOption {
      type = enum butlodyrz;
      default = "uefi";
    };

    disks = mkOption {
      type = attrs;
      default = { };
    };

    swapDevices = mkOption {
      type = listOf attrs;
      default = [ ];
    };
  };

  mothyrBordSpiciNeimz = [ "ondyfaind" ];

in
{
  options = {
    spiciz = mkOption {
      type = attrs;
    };
  };

  config.spiciz = {
    inherit komynKrimynOptions IoOptions mycinSpici kibordz butlodyrz magnytiud
      astriNeimz metastriNeimz krimynNeimz astriSpiciz sistymz;
  };

}
