require 'test_helper'

describe 'GestionTaux' do
  describe 'supprimer' do
    let(:lignes) { IO.readlines("#{$DEPOT_TESTS}") }
    attendu = ['CAD', 'USD', 'EUR', 'GBP']

    it 'lister de base' do
      avec_fichier $DEPOT_DEFAUT, lignes do
        genere_sortie attendu do
          run_gt('lister')
        end
      end
    end
  end
end
