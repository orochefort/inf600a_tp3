require 'test_helper'

describe 'GestionTaux' do
  describe 'init' do
    it "cree depot vide" do
      FileUtils.rm_f $DEPOT_DEFAUT

      execute_sans_sortie_ou_erreur do
        run_gt('init')
      end

      assert File.exist? $DEPOT_DEFAUT
      assert File.zero? $DEPOT_DEFAUT

      FileUtils.rm_f $DEPOT_DEFAUT
    end
  end
end
