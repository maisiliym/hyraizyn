{ config, kor, ... }:
let
  inherit (builtins) filter concatStringsSep listToAttrs hasAttr attrNames concatMap elem;
  inherit (kor) louestOf nameValuePair filterAttrs spiciDatum optional mapAttrsToList
    optionalString arkSistymMap;
  inherit (config) metastriz metastraNeim astraNeim krimynNeim;
  inherit (config.spiciz) astriNeimz metastriNeimz krimynNeimz;

  inputMetastra = metastriz.${metastraNeim};
  inputAstriz = inputMetastra.astriz;
  inputAstra = inputAstriz.${astraNeim};

  metaUniksNeim = concatStringsSep "."
    [ metastraNeim "uniks" ];

  metaTrost = inputMetastra.trost.metastra;

  mkTrost = yrei: louestOf (yrei ++ [ metaTrost ]);

  mkEseseitcString = priKriom:
    if (priKriom == null) then "" else
    concatStringsSep " " [ "ssh-ed25519" priKriom ];

  mkAstri = astriNeim:
    let
      inputAstri = inputAstriz.${astriNeim};
      inherit (inputAstri.priKriomz) yggdrasil;

      filteredMycin = spiciDatum {
        datum = inputAstri.mycin;
        spek = {
          metyl = [ "ark" "mothyrBord" "modyl" ];
          pod = [ "ark" "ubyrAstri" "ubyrKrimyn" ];
        };
      };

      rytyrnArkFromMothyrBord = mb: abort "Missing mothyrBord table";

      tcekdArk =
        if (filteredMycin.ark != null)
        then filteredMycin.ark
        else if (filteredMycin.spici == "pod")
        then astriz.${filteredMycin.ubyrAstri}.mycin.ark
        else if (filteredMycin.mothyrBord != null)
        then (rytyrnArkFromMothyrBord filteredMycin.mothyrBord)
        else abort "Missing mycin ark";

      mycin = filteredMycin // { ark = tcekdArk; };

      astri = {
        neim = astriNeim;
        inherit (inputAstri) saiz spici;

        trost = mkTrost
          [ inputAstri.trost inputMetastra.trost.astriz.${astriNeim} ];

        eseseitc = mkEseseitcString inputAstri.priKriomz.eseseitc;

        yggPriKriom = yggdrasil.priKriom;
        yggAddress = yggdrasil.address;
        yggSubnet = yggdrasil.subnet;

        inherit (inputAstri.priKriomz) niksPriKriom;

        uniksNeim = concatStringsSep "."
          [ astriNeim "astriz" metaUniksNeim ];

        inherit mycin;
        sistym = arkSistymMap.${mycin.ark};

        nbOfBildKorz = 1; #TODO
      };

      spinyrz =
        let
          inherit (astri) spici trost saiz niksPriKriom
            yggAddress uniksNeim;

        in
        rec {
          saizAtList = kor.mkSaizAtList saiz;
          izEdj = spici == "edj";
          izSentyr = spici == "sentyr";
          izHaibrid = spici == "haibrid";
          izBildyr = !izEdj && (trost >= 3) && saizAtList.med && izNiksKriodaizd;
          izDispatcyr = !izSentyr && (trost >= 3) && saizAtList.min;
          izNiksKac = !izEdj && saizAtList.max && izNiksKriodaizd;
          izNiksKriodaizd = niksPriKriom != null;
          izYggKriodaizd = yggAddress != null;
          izNeksisKriodaizd = izYggKriodaizd;
          izEseseitcKriodaizd = hasAttr "eseseitc" inputAstri.priKriomz;

          izKriodaizd = izNiksKriodaizd && izYggKriodaizd && izEseseitcKriodaizd;

          eseseitcPriKriom =
            if !izEseseitcKriodaizd then ""
            else mkEseseitcString inputAstri.priKriomz.eseseitc;

          nixPriKriom = optionalString izNiksKriodaizd
            (concatStringsSep ":" [ uniksNeim niksPriKriom ]);
        };

    in
    astri // { inherit spinyrz; };

  exAstriNeimz = attrNames exAstriz;
  bildyrz = filter (n: astriz.${n}.spinyrz.izBildyr) exAstriNeimz;
  kacyz = filter (n: astriz.${n}.spinyrz.izNiksKac) exAstriNeimz;
  dispatcyrz = filter (n: astriz.${n}.spinyrz.izDispatcyr) exAstriNeimz;

  adminKrimynNeimz = filter (n: krimynz.${n}.trost == 3) krimynNeimz;

  astraSpinyrz =
    let
      mkBildyr = n:
        let astri = exAstriz.${n};
        in
        {
          hostname = astri.uniksNeim;
          sshUser = "niksBildyr";
          sshKey = "/root/.ssh/id_ed25519";
          system = astri.sistym;
          maxJobs = astri.nbOfBildKorz;
        };

      mkAdminKrimynPriKriomz = adminKrimynNeim:
        let
          adminKrimyn = krimynz.${adminKrimynNeim};
          priKriomAstriNeimz = attrNames adminKrimyn.priKriomz;
          izAstriFulyTrostyd = n: astriz.${n}.spinyrz.izDispatcyr;
          fulyTrostydPriKriomNeimz = filter izAstriFulyTrostyd priKriomAstriNeimz;
          getEseseitcString = n:
            if (adminKrimyn.priKriomz.${n}.eseseitc == null)
            then "" else (mkEseseitcString adminKrimyn.priKriomz.${n}.eseseitc);
        in
        map getEseseitcString fulyTrostydPriKriomNeimz;

      thinkpadModylz = [ "ThinkPad X240" "ThinkPad X230" ];
      impozdHTModylz = [ "ThinkPad X240" ];

    in
    {
      bildyrKonfigz =
        let
        in
        map mkBildyr bildyrz;

      kacURLz =
        let
          mkKacURL = n: "niks." + exAstriz.${n}.uniksNeim;
        in
        map mkKacURL kacyz;

      exAstrizEseseitcPriKriomz = map
        (n:
          exAstriz.${n}.eseseitc
        )
        exAstriNeimz;

      dispatcyrzEseseitcKiz = map
        (n:
          exAstriz.${n}.eseseitc
        )
        dispatcyrz;

      adminEseseitcPriKriomz = concatMap mkAdminKrimynPriKriomz adminKrimynNeimz;

      tcipIzIntel = elem astra.mycin.ark [ "x86-64" "i686" ]; # TODO

      modylIzThinkpad = elem astra.mycin.modyl thinkpadModylz;

      impozyzHaipyrThreding = elem astra.mycin.modyl impozdHTModylz;

      iuzColemak = astra.io.kibord == "colemak";
    };

  mkKrimyn = krimynNeim:
    let
      inputKrimyn = inputMetastra.krimynz.${krimynNeim};

      tcekPriKriom = astriNeim: priKriom:
        hasAttr astriNeim astriz;

      krimyn = {
        neim = krimynNeim;

        inherit (inputKrimyn) spici kibord;

        saiz = louestOf [ inputKrimyn.saiz astra.saiz ];

        trost = inputMetastra.trost.krimynz.${krimynNeim};

        priKriomz = filterAttrs tcekPriKriom inputKrimyn.priKriomz;

      };

      hazPriKriom = hasAttr astra.neim krimyn.priKriomz;

      spinyrz = {
        inherit hazPriKriom;

        saizAtList = kor.mkSaizAtList krimyn.saiz;

        matrixID = "@${krimyn.neim}:${metastra.neim}.uniks";

        gitSigningKey =
          if hazPriKriom then
            ("&" + krimyn.priKriomz.${astra.neim}.keygrip)
          else null;

        iuzColemak = krimyn.kibord == "colemak";

        izSemaDev = elem krimyn.spici [ "Sema" "Onlimityd" ];
        izUniksDev = elem krimyn.spici [ "Uniks" "Onlimityd" ];

      } // (kor.optionalAttrs hazPriKriom {
        astraSshPubkey = mkEseseitcString krimyn.priKriomz.${astra.neim}.eseseitc;

        metastraEseseitcyz = mapAttrsToList (n: pk: mkEseseitcString pk.eseseitc)
          krimyn.priKriomz;
      });

    in
    krimyn // { inherit spinyrz; };

  astriz = listToAttrs (map
    (y: nameValuePair y.neim y)
    (filter (x: x.trost != 0)
      (map (n: mkAstri n) astriNeimz)));

  metastra = {
    neim = metastraNeim;

    spinyrz = {
      trostydBildPriKriomz = map (n: exAstriz.${n}.spinyrz.nixPriKriom) bildyrz
        ++ (optional astra.spinyrz.izNiksKriodaizd astra.spinyrz.nixPriKriom);
    };
  };

  exAstriz = kor.filterAttrs (n: v: n != astraNeim) astriz;

  astra =
    let
      astri = astriz.${astraNeim};
    in
    astri // {
      inherit (inputAstra) io;
      spinyrz = astri.spinyrz // astraSpinyrz;
    };

  krimynz = listToAttrs (map
    (y: nameValuePair y.neim y)
    (filter (x: x.trost != 0)
      (map (n: mkKrimyn n) krimynNeimz)));

  krimyn = krimynz.${krimynNeim};

in
{
  config.hyraizyn = {
    inherit metastra astra exAstriz krimyn krimynz;
  };
}
