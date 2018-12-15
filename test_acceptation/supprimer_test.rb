require 'test_helper'

describe 'GestionTaux' do
  describe 'supprimer' do
    let(:lignes) { IO.readlines("#{$DEPOT_TESTS}") }

    it 'suppression devise cad' do
      nouveau_contenu = avec_fichier $DEPOT_DEFAUT, lignes, :conserver do
        execute_sans_sortie_ou_erreur do
          run_gt("supprimer 'CAD'")
        end
      end

      nouveau_contenu.find { |l| l =~ /^CAD/ }.must_be_nil
      nouveau_contenu.size.must_equal 3

      FileUtils.rm_f $DEPOT_DEFAUT
    end
  end
end
