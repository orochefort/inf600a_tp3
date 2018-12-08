module GestionTaux

  # @author Guy Tremblay, Olivier Rochefort
  #
  # Objet singleton (on dit aussi une 'machine') qui encapsule
  # l'entrepot de donnees pour les taux. Ne definit donc que des
  # methodes 'de classe', sans methode d'instances, puisqu'on aura
  # toujours un seul entrepot actif a un instant donne -- pas
  # d'execution concurrente.
  #
  # Plus specifiquement, cet objet sert de "repository" (traduit par
  # 'entrepot') au sens defini par l'approche DDD d'Eric Evans:
  # 'Domain-Driven Design---Tackling Complexity in the Heart of
  # Software', Addison-Wesley, 2004.
  #
  class EntrepotDevises

    # Initialise l'entrepot, i.e., charge en memoire la collection de
    # taux specifiee par le depot, et ce a l'aide de la bd indiquee.
    #
    # @param [String] depot Le nom de la base de donnees.
    # @param [<#charger, #sauver>] bd La base de donnees a utiliser.
    #
    # @return [void]
    #
    # @ensure les_taux Contient les taux du fichier.
    #
    def self.ouvrir(depot, bd)
      @depot = depot
      @bd = bd
      @les_taux = @bd.charger(depot)
    end

    # Ferme l'entrepot, ce qui a pour effet de le sauvegarder dans le
    # fichier associe.
    #
    # @return [void]
    #
    # @require Un appel prealable a ouvrir a ete effectue.
    # @ensure Les taux ont ete sauvegardes dans le depot.
    #
    def self.fermer
      DBC.require(@depot && @bd, "Aucun appel prealable a ouvrir ne semble avoir ete effectue")

      @bd.sauver(@depot, @les_taux)
    end

    # Ajoute un taux dans la collection des taux.
    #
    #
    # @param [String] a_nom Chaine de trois lettres identifiant la devise.
    # @param [String] *a_devises_conversion Une (ou plusieurs) chaines representant
    #  les devises de conversion. Chaque chaine de texte doit etre au format
    #  <nom devise>:<taux> (ex : USD:1.32901).
    #
    # @return [void]
    #
    # @ensure Un taux a ete ajoute dans dans le depot si les
    #         conditions decrites dans Devise.new etaient satisfaites
    #
    def self.ajouter(a_nom, a_devises_conversion)
        puts "#{a_nom} - #{a_devises_conversion}"
        @les_taux << Devise.new(a_nom, a_devises_conversion)
    end

    # Supprime un taux du depot.
    #
    # @param [Devise] a_devise La devise a supprimer.
    # @param [String] a_nom Chaine de trois lettres identifiant la devise pour
    #   laquelle supprimer toutes les infos sur les taux.
    #
    # @return [void]
    #
    # @require Exactement un parmi a_devise: ou a_nom: est specifie, pas les deux.
    #
    # @ensure La devise specifiee n'est plus presente dans le depot.
    #
    # @raise [::GestionTaux::Exception] si le taux indique n'existe pas
    #
    def self.supprimer(a_devise: nil, a_nom: nil)
      DBC.require(a_devise && a_nom.nil? || a_nom && a_devise.nil?,
                  "#{self}.supprimer: Il faut indiquer un seul argument.")

      if a_nom
        #todo
        devise = GT::EntrepotDevises.selectionner(a_nom)
        fail ::GestionTaux::Exception, "#{self}.supprimer:  #{numero} n'existe pas" unless vin
      end

      fail ::GestionVins::Exception, "#{self}.supprimer: le vin numero #{numero} est deja note" if vin.note?

      supprime = @les_taux.delete(vin)

      DBC.assert supprime, "#{self}.supprimer: le vin #{vin} n'existait pas dans #{self}"
    end


    # Retourne le vin avec le numero indique.
    #
    # @param [Integer] numero
    #
    # @return [Vin] le vin avec le numero indique
    #
    def self.le_vin(numero)
      @les_taux.find { |v| v.numero == numero }
    end
  end
end
