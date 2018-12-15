require 'test_helper'

describe 'GestionTaux' do
  describe 'supprimer' do
    let(:lignes) { IO.readlines("#{$DEPOT_TESTS}") }
    attendu = ['0.74775']

    it 'obtention taux cad en usd' do
      avec_fichier $DEPOT_DEFAUT, lignes do
        genere_sortie attendu do
          run_gt("taux_devise 'CAD' 'USD'")
        end
      end
    end
  end
end
