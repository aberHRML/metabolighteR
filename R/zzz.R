.onLoad <-
  function(libname = find.package('metabolighteR'),
           pkgname = 'metabolighteR')
  {

    assign('BASE_URL', 'https://www.ebi.ac.uk:443/metabolights/ws', env = .GlobalEnv)

  }


