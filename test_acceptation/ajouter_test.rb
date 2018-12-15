require 'test_helper'

describe 'GestionTaux' do
  describe 'ajouter' do
    let(:lignes) { IO.readlines("#{$DEPOT_TESTS}") }
    attendu = 'AUD;CAD:0.96015;USD:0.71793;EUR:0.63510;GBP:0.57069'

    it 'ajouter nouvelle devise' do
      nouveau_contenu = avec_fichier $DEPOT_DEFAUT, lignes, :conserver do
        execute_sans_sortie_ou_erreur do
          run_gt("ajouter 'AUD' 'CAD:0.96015' 'USD:0.71793' 'EUR:0.63510' 'GBP:0.57069'")
        end
      end

      nouveau_contenu.last.must_equal attendu
    end
  end
end
