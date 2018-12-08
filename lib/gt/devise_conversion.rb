require_relative 'motifs'

# Classe representant une devise de conversion; c-a-d une devise a laquelle une
# autre devise (de classe Devise) se refere pour obtenir un taux de conversion.
#
# @author Olivier Rochefort
#
class DeviseConversion
  READERS = [:nom, :taux]
  attr_reader(*READERS)

  # Methode d'initialisation d'une devise de conversion.
  #
  # @author Olivier Rochefort
  #
  # @param [String] a_nom Chaine de trois lettres identifiant la devise.
  # @param [Float] a_taux Taux de conversion.
  #
  def initialize(a_nom, a_taux)
    DBC.require(Motifs::NOM_DEVISE =~ a_nom,
                'Nom de devise de conversion invalide. Le nom doit etre une chaine d\'exactement trois lettres.')
    DBC.require(/^#{Motifs::TAUX}$/ =~ a_taux.to_s,
                "Taux ('#{a_taux}') invalide. Le taux doit etre un nombre decimal positif.")

    @nom = a_nom.upcase
    @taux = a_taux
  end

  # Retourne les donnees au format CSV.
  #
  # @author Olivier Rochefort
  #
  def to_csv
    "#{@nom}:#{@taux}"
  end
end
