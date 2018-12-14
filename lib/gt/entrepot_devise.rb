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

    # Ajoute une devise dans la collection des taux.
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
    def self.ajouter(a_nom_devise, *a_devises_conversion)
      devise = selectionner(a_nom_devise)
      raise ::GestionTaux::Exception, "#{self}.ajouter: la devise '#{a_nom_devise}' existe deja" if devise

      @les_taux << Devise.new(a_nom_devise, *a_devises_conversion)
    end

    # Ajoute des devises de conversion a une devise existante.
    #
    # @param [String] a_devise Chaine de trois lettres identifiant le nom de la devise existante.
    # @param [String] *a_devises_conversion Une (ou plusieurs) chaines representant
    #  les devises de conversion. Chaque chaine de texte doit etre au format
    #  <nom devise>:<taux> (ex : USD:1.32901).
    #
    # @return [void]
    #
    # @ensure Un taux a ete ajoute dans dans le depot si les
    #         conditions decrites dans Devise.new etaient satisfaites
    #
    def self.ajouter_devises_conversion(a_nom_devise, *a_devises_conversion)
      devise = selectionner(a_nom_devise)
      raise ::GestionTaux::Exception, "#{self}.ajouter_devise_conversion: la devise '#{a_nom_devise}' n'existe pas" unless devise

      devise.ajouter_devises_conversion(*a_devises_conversion)
    end

    # Supprime une devise du depot.
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
        devise = GT::EntrepotDevises.selectionner(a_nom)
        raise ::GestionTaux::Exception, "#{self}.supprimer: La devise '#{a_nom}' n'existe pas" unless devise
      end

      supprime = @les_taux.delete(devise)

      DBC.assert supprime, "#{self}.supprimer: La devise '#{a_nom}' n'existait pas dans #{self}"
    end

    # @return [Array<Devise>] Tous les taux dans la collection
    #
    def self.les_taux
      @les_taux
    end

    # Retourne la devise portant le nom specifie.
    #
    # @param [String] a_nom Chaine de trois lettres identifiant la devise.
    #
    # @return [Devise] La devise portant le nom indique
    #
    def self.selectionner(a_nom)
      @les_taux.find { |d| d.nom == a_nom }
    end
  end
end
