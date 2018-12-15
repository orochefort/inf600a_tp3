# @author Guy Tremblay, Olivier Rochefort
#
require 'rake/clean'
require 'rubygems'
require 'rake/testtask'

# ---------- Parametres generaux

UTILISE_WINDOWS = !!((RUBY_PLATFORM =~ /(win|w)(32|64)$/) || (RUBY_PLATFORM =~ /mswin|mingw/))

# Pour lancer l'execution d'un exemple.
GT = UTILISE_WINDOWS ? 'bundle exec ruby bin\\gt' : 'bundle exec bin/gt'

# Unite a executer ou a tester par defaut.
task :default => :exemples
task :all => [:test_acceptation]
#task :default => :all

# Les differents exemples et tests d'acceptation.
COMMANDES = [:init, :lister, :ajouter, :supprimer, :taux_devise]

# ---------- Methodes auxiliaires

# Methodes auxilaires pour generer un nom de cible: cf. plus bas.
class Symbol
  def exemples; "#{self.to_s}_exemples".to_sym end
  def acceptation; "#{self.to_s}_test_acceptation".to_sym end
  def unitaire; "#{self.to_s}_test".to_sym end
end

# Methode auxiliaire pour definir les taches associes aux differentes
# commandes, tant unitaires que d'acceptation.
#
def test_task(commande, sorte)
  raise "Sorte de test invalide: #{sorte}" unless [:unitaire, :acceptation].include?(sorte)

  suffixe = sorte == :unitaire ? '' : '_acceptation'
  repertoire = "test#{suffixe}"
  nom_tache = "#{commande}_test#{suffixe}".to_sym

  desc "Tests #{sorte == :unitaire ? 'unitaires' : 'd\'acceptation'} #{nom_tache.to_s.sub(/_.*/, '')}"
  task nom_tache do
    sh "rake #{repertoire} TEST=#{repertoire}/#{commande}_test.rb"
  end
end

# ---------- Exemples

task :exemples => COMMANDES.map { |cmd| "#{cmd}_exemples".to_sym }

def gt(cmd, lister_apres: nil)
  system UTILISE_WINDOWS ? 'copy /Y test_acceptation\\4taux.txt .taux.txt >NUL' : 'cp -f test_acceptation/4taux.txt .taux.txt'
  puts "*** #{GT} #{cmd} ***"
  system "#{GT} #{cmd}"
  puts
  system "#{GT} lister --raw" if lister_apres
  puts
end

task :init_exemples do
  gt 'init', lister_apres: true
  gt 'init --detruire', lister_apres: true
end

task :lister_exemples do
  gt 'lister'
  gt 'lister --raw'
end

task :ajouter_exemples do
  gt "ajouter 'AUD' 'CAD:0.96015' 'USD:0.71793' 'EUR:0.63510' 'GBP:0.57069'", lister_apres: true
  gt "ajouter --append 'CAD' 'CNY:5.16315'", lister_apres: true
end

task :supprimer_exemples do
  gt "supprimer 'USD'", lister_apres: true
end

task :taux_devise_exemples do
  gt "taux_devise 'CAD' 'USD'", lister_apres: true
  gt "taux_devise 'USD' 'MXN'", lister_apres: true
end

#############################################################################

# On definit des cibles distinctes pour les tests unitaires des
# classes et les tests d'acceptation des commandes.
COMMANDES.each { |cmd| test_task cmd, :acceptation }

#############################################################################

# Cible pour l'ensemble des tests unitaires.
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

# Cible pour l'ensemble des tests d'acceptation.
Rake::TestTask.new(:test_acceptation) do |t|
  t.libs << "test_acceptation"
  t.test_files = FileList['test_acceptation/*_test.rb']
  t.warning = false
end

#############################################################################
