module GestionTaux

    require_relative 'motifs'

# Classe representant une devise et ses differentes devises de conversion.
#
# @author Olivier Rochefort
#
class Devise

  @@les_noms = []
  READERS = [:nom, :devises_conversion]
  attr_reader(*READERS)

  # Methode d'initialisation d'une devise a partir d'une entree CSV.
  #
  # @author Olivier Rochefort
  #
  # @param [String] a_ligne Une entree CSV.
  # @param [String] a_separateur Le caractere separateur dans l'entree CSV.
  #
  def self.new_from_csv(a_ligne, a_separateur = ';')
    nom, *devises_conversion = a_ligne.split(a_separateur)
    new(nom, *devises_conversion)
  end

  # Setter personnalise pour l'attribut devises_conversion.
  #
  # @author Olivier Rochefort
  #
  # @param [String] *a_devises_conversion Une (ou plusieurs) chaines representant
  #  les devises de conversion. Chaque chaine de texte doit etre au format
  #  <nom devise>:<taux> (ex : USD:1.32901).
  #
  def devises_conversion=(*a_devises_conversion)
    return unless a_devises_conversion && a_devises_conversion.any?

    a_devises_conversion.each do |dc|
      nom_devise, taux = dc.to_s.scan(Motifs::DEVISE_CONVERSION).flatten
      DBC.require(nom_devise && taux,
                  'Devise de conversion invalide. Le format doit etre <nom devise>:<taux> (ex : USD:1.32901).')

      @devises_conversion << DeviseConversion.new(nom_devise, taux)
    end
  end

  # Methode d'initialisation d'une devise.
  #
  # @author Olivier Rochefort
  #
  # @param [String] a_nom Chaine de trois lettres identifiant la devise.
  # @param [String] *a_devises_conversion Une (ou plusieurs) chaines representant
  #  les devises de conversion. Chaque chaine de texte doit etre au format
  #  <nom devise>:<taux> (ex : USD:1.32901).
  #
  def initialize(a_nom, *a_devises_conversion)
    DBC.require(Motifs::NOM_DEVISE =~ a_nom,
                'Nom de devise invalide. Le nom doit etre une chaine d\'exactement trois lettres.')
    
    @devises_conversion = []
    a_devises_conversion.each do |dc|
      nom_devise, taux = dc.to_s.scan(Motifs::DEVISE_CONVERSION).flatten
      DBC.require(nom_devise && taux,
                  'Devise de conversion invalide. Le format doit etre <nom devise>:<taux> (ex : USD:1.32901).')

      @devises_conversion << DeviseConversion.new(nom_devise, taux)
    end
    @nom = a_nom.upcase
    @@les_noms = []
  end

  def self.les_noms
    @@les_noms
  end

  # Retourne les donnees au format CSV.
  #
  # @author Olivier Rochefort
  #
  # @param [String] a_separateur Le caractere separateur a utiliser.
  #
  def to_csv(a_separateur = ';')
    @nom + a_separateur + @devises_conversion.map(&:to_csv).join(a_separateur)
  end
end
end
