module Motifs
  NOM_DEVISE = %r{[a-zA-Z]{3}}
  TAUX = %r{\d+\.\d+}
  DEVISE_CONVERSION = %r{(#{NOM_DEVISE}):(#{TAUX})}
end
