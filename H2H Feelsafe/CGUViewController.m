//
//  CGUViewController.m
//  H2H Feelsafe
//
//  Created by Maxime Berail on 28/12/13.
//  Copyright (c) 2013 Maxime Berail. All rights reserved.
//

#import "CGUViewController.h"

@interface CGUViewController ()

@end

@implementation CGUViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"CGU";
    self.textView.textAlignment = NSTextAlignmentJustified;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Accepter",nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissCGU)];
    self.navigationItem.rightBarButtonItem = item;
    NSString *htmlString = NSLocalizedString(@"<h1>Conditions Générales d\'Utilisation (CGU)</h1><i>Version en vigueur au 6 Janvier 2014</i><p>Les présentes Conditions Générales d’Utilisation  ou « CGU » ont pour objet de définir les modalités de mise à disposition de  l’application mobile et des Services associés H2H feelsafe par la société H2H mobility (ci-après, « le ou les Service(s) » ou « feelsafe »).</p><p>Tout Utilisateur de l’application (ci-après « l’Utilisateur »), ayant coché la case « J’accepte les conditions générales » reconnaît avoir lu attentivement les présentes CGU avant de faire usage des Services feelsafe.  L’Utilisateur est réputé être une personne physique agissant dans un cadre non professionnel.</p><p>L’utilisation de l’application mobile feelsafe vaut acceptation sans réserve des présentes Conditions Générales d’Utilisation (ci-après les « CGU » ou « les Conditions ») par l\'Utilisateur. Elles constituent un contrat indivisible entre feelsafe et l\'Utilisateur.</p><p>Ces règles ont été édictées dans le respect de la législation française et communautaire en vigueur.</p><h2>1. Définitions</h2><p>La signification des principaux termes utilisés dans les Conditions Générales d’Utilisation est indiquée ci-après :H2H feelsafe (ou feelsafe) : application mobile développée par la société H2H mobility, regroupant un  ensemble de Services pouvant évoluer dans le temps.</p><p><b>CGU</b> : Conditions Générales d\'Utilisation désignant le présent contrat et s\'appliquant, sans restriction ni réserve, à l\'ensemble des Services proposés par feelsafe de H2H mobility.</p><p> <b>Accord</b> : Accord passé entre l’Utilisateur et H2H mobility à travers les Conditions Générales d\'Utilisation (CGU). <b>Utilisateur</b> : Désigne toute personne physique faisant usage de l’application feelsafe et des Services associés.<b>Service(s)</b> : Décrit l’ensemble des  services offerts par l’application feelsafe. <b>GPS</b> : Global Positioning System.<b>Smartphone</b> : Téléphone mobile disposant des fonctions d\'assistant numérique personnel, et de fonctions GPS.Application mobile : Logiciel applicatif installé et utilisé sur un téléphone mobile de type Smartphone, ou sur tout appareil mobile, y compris tablettes et autres objets communicants. Il est entendu que l’application ne pourra fonctionner que sur les environnements et les versions qu’elle supporte.Identifiants : Désigne les informations permettant à un compte Utilisateur l’accès à l’application feelsafe. Chaque compte est rattaché à un « login » et à un mot de passe fourni par l’Utilisateur et dont celui-ci assume l’entière responsabilité quant à son niveau de sécurité.<b>Référent</b> : Désigne la ou les personnes utilisant l’application feelsafe pour suivre et sécuriser les personnes potentiellement à risque, appelées « Protégés ». Le Référent peut également être appelé « Ange Gardien » dans la terminologie propre aux Services.Compte Référent : Compte créé par le Référent dans l’application feelsafe, lui permettant de s’authentifier en utilisant le « login » et mot de passe qu’il aura fournis, et d’accéder aux diverses fonctionnalités de l’application liées à son compte.<b>Protégé</b> : Désigne les personnes suivies par le(s) Référent(s) à travers l’application feelsafe, et pouvant via cette application être localisés, et envoyer une alerte.Compte Protégé : Compte créé par le Protégé dans l’application feelsafe, lui permettant de s’authentifier en utilisant le « login » et mot de passe qu’il aura fournis, et d’accéder aux diverses fonctionnalités de l’application liées à son compte.<b>Service(s)</b> : Décrit l’ensemble des services mis à disposition à travers l’application.Droit de propriété intellectuelle : Désigne collectivement d\'une part, la \"propriété littéraire et artistique\" et d\'autre part, la \"propriété industrielle\", incluant les brevets, droits d’auteur, droits de reproduction, et tout autre droit acquis et reconnaissant une propriété intellectuelle.</p><h2>2. Utilisation de nos Services</h2><p>H2H feelsafe est une application mobile, offrant un Service d’aide à la personne basé sur la géolocalisation et sur la communication à travers des fonctions de notification et d’envoi d’alertes multi-canaux. Cette application, développée par la société H2H mobility, permet de  suivre et de protéger des personnes potentiellement fragiles, et/ou susceptibles de se retrouver en situation de danger à tout moment (enfants, personnes âgées, personnes neuro-déficientes, personnes subissant des violences répétées,…). L’accord préalable des  Protégés à être localisés par tel ou tel Référent doit nécessairement être recueilli par avance. L’Utilisateur reconnaît, avant toute mise en œuvre, avoir recueilli ledit accord de l’intéressé ou de son représentant légal.</p><p>Le Protégé peut à tout moment désactiver l’application, en particulier la localisation GPS, et supprimer librement un ou plusieurs Référent(s).Pour accéder au Service, il faut que chaque Utilisateur ait en sa possession un smartphone compatible avec l’application feelsafe. L’application doit être téléchargée et installée sur le smartphone selon la procédure applicable à chaque marque et chaque modèle. H2H mobility ne peut être tenu responsable en cas de dysfonctionnement causé par une mauvaise installation incomplète, une faiblesse ou absence du signal réseau / Wi-fi ou GPS,  ou en violation des règles visant à protéger les droits de propriété intellectuelle.Chaque Utilisateur fait son affaire de la vérification de la compatibilité de l’application avec son smartphone, conformément aux spécifications ci-après. L’utilisation de l’application feelsafe implique :<ul><li>La possession d’un mobile de type Smartphone intégrant une version Androïd 3.0 ou supérieure, ou une version IOS 6 ou supérieur.</li><li>Le  téléchargement de l’application feelsafe  sur le mobile, incluant la possession au préalable d’un compte Google actif, pour l’accès à l’application via « Google Play »</li><li>L’activation du GPS sur le mobile et d’une connexion réseau</li><li>La création de comptes et profils feelsafe  par l’Utilisateur, comme décrit plus bas.</li></ul>L’Utilisateur est avisé qu’il demeure responsable, pour les Smartphones utilisant une carte SIM, de la souscription d’un abonnement auprès de l’opérateur de son choix.L’Utilisateur accepte que H2H mobility puisse mettre à jour, à sa discrétion, l’application par une version mineure ou majeure, ou simplement pour la correction ou amélioration d’une fonction de l’application, par un mécanisme automatique. Les présentes CGU s’appliquent également aux versions mises à jour ultérieures.</p><h3>2.1 - Personnes éligible et restriction</h3><p>Est utilisable toute application et services offerts par H2H mobility dès acceptation des termes et conditions d’utilisation décrites dans les présentes CGU, et strict respect des lois et législations locales et nationales en vigueur. Toute personne mineure ou sous tutorat ne devra accepter l’invitation d’un Référent et l’utilisation de son profil qu’après approbation d’un de ses parents ou tuteur légal. La société H2H mobility se dégage de toute responsabilité au cas où une personne mineure ou sous tutorat, utilise l’application sans avoir obtenu cet accord. Les Services H2H mobility ne pourront être accessibles par les Utilisateurs ayant été radiés et/ou dont le compte aurait été supprimé sur décision de H2H mobility. </p><h3>2.2 - Limites d’utilisation de feelsafe</h3><p>L’Utilisateur ne peut utiliser l’application feelsafe  et les services attenants  que  pour son usage personnel, et exclusivement à des fins non-commerciales. En aucun cas il ne peut le commercialiser ou le détourner de sa finalité qui est de sécuriser les Protégés à travers cette application. En outre l’Utilisateur s’interdit de procéder à toute reproduction provisoire ou permanente de  feelsafe ou autre application fournie par H2H mobility, par quelque moyen que ce soit, ainsi qu’à toute traduction, adaptation, arrangement, décompilation ou modification de feelsafe ou toute autre application notamment en vue de la création d’une solution similaire. Tout manquement aux présentes CGU entraînera automatiquement la fermeture du Compte Utilisateur. En pareille hypothèse, aucun remboursement ou compensation d’aucune sorte ne pourra être réclamé par l’Utilisateur ou ancien Utilisateur.</p><h3>2.3 - Création de compte et  données Utilisateurs</h3><p>L’utilisation de l’application feelsafe  par le Référent ou le Protégé suppose la création d’un compte Utilisateur pour le Référent ci-après le “Compte Référent” ou le “Compte Référent”, nécessitant :<ul><li>la fourniture de données à caractère personnel, dont une adresse e-mail ou courriel valide et consultée régulièrement (l’adresse mail permettant de s’authentifier et de recevoir les alertes le cas échéant)</li><li>un numéro de mobile fonctionnel (optionnel)</li><li>un pseudonyme</li></ul>A défaut, l’ouverture du Compte Référent ou Protégé ne sera pas autorisée. L’Utilisateur est seul responsable des données personnelles qu’il fournit, sachant que la fourniture du nom et du prénom demeure facultative. Toutefois, s’il choisit de remplir ce champ, il s’engage à fournir ses véritables patronyme et prénom.<br/>L’Utilisateur détermine sous sa seule responsabilité le mot de passe associé à son login ou compte utilisateur, notamment s’agissant du niveau de protection. H2H mobility ne peut être tenu responsable en cas d’accès par une personne non autorisée. L’utilisation des données à caractère personnel des Utilisateurs saisies pour les besoins de la création des Compte Référent ou Protégé est régie par l’article « Responsabilités » des présentes CGU.<br/>Les informations saisies par l’Utilisateur quel qu’il soit sont personnelles et confidentielles. Elles ne peuvent être modifiées que par l’Utilisateur. L’Utilisateur s’engage à mettre tout en œuvre, sous sa seule responsabilité, pour conserver secrètes l’ensemble des informations saisies, notamment les Identifiants et à ne pas les divulguer sous quelque forme que ce soit. L’Utilisateur est seul responsable de l’utilisation des Identifiants et de la garde des codes d’accès créés. Il s’assurera qu’aucun tiers non autorisé par lui n’a accès à son compte feelsafe.  Dans l’hypothèse où il aurait connaissance d’un accès non autorisé à son compte feelsafe  via ses Identifiants ou d’une autre façon, l’Utilisateur devra en informer sans délai la société H2H mobility afin qu’elle prenne toutes les mesures nécessaires à la sécurisation des accès de l’Utilisateur. En cas de perte ou oubli d’un des Identifiants, l’Utilisateur  contactera par email la société H2H mobility afin qu’elle lui fournisse un nouvel Identifiant ou lui fournisse les informations manquantes, après vérification de l’identité de l’Utilisateur.</p><h3>2.4 - Règles d’utilisation du Service</h3><p>L’Utilisateur s’engage à ne pas contribuer ou participer à des activités illégales et/ou non autorisées par H2H mobility telles que : copier, distribuer, ou divulguer tout ou partie de l’application et des services associés dans quelques média que ce soit ; utiliser un ou des systèmes d’automates quels qu’ils soient dans le but notamment d’atteindre le Service en générant plus de requêtes que ce qu’un traitement humain pourrait générer de façon raisonnable dans un même lapse de temps ; transmettre des spams, ou autre mode d’interaction et de sollicitation illicite; essayer d’interférer et de compromettre la sécurité et l’intégrité du système mis en place par H2H mobility ; déchiffrer toute transaction entrante ou sortante du serveur sur lequel tourne le Service ; mettre en œuvre des actions qui pourraient compromettre le fonctionnement de notre infrastructure ou la sécurité des données Utilisateurs et des profils correspondants ; collecter sans autorisations les données, comptes ou informations gérées par notre infrastructure ; mettre en œuvre des actions qui pourraient surcharger de façon notable notre infrastructure et impacter notamment les temps de réponses Utilisateurs ; utiliser notre plateforme et applications pour charger ou faire transiter des virus, ou toute autre forme d’agent ou logiciel à des fins de nuire ; utiliser les Services H2H mobility à des fins commerciales ; cacher son identité ou utiliser un profil de manière frauduleuse ou en vue de nuire à quelque personne que ce soit à travers nos Services ; accéder à nos Services via d’autres technologies que celles mise en œuvres et fournies par H2H mobility; aller à l’encontre des décisions prises par H2H mobility pour le bon fonctionnement de ses Services et pour la sécurité de ses Utilisateurs. Les Services offerts par H2H mobility pourront être modifiés, stoppés ou réduits en terme d’utilisation pour tout ou partie des Utilisateurs sans notification préalable. Ceci notamment au cas où un service fourni par une société tierce et utilisé par H2H mobility venait à être défaillante ou tomber en panne momentanément. H2H mobility dans ce cas se chargera de contacter la société fournissant ce service pour obtenir des informations, et éventuellement les communiquer à ses Utilisateurs, mais se désengage totalement des conséquences liées à cette défaillance, et ne prend aucun engagement sur le temps de résolution de cette panne ou défaillance. Nous incluons dans le terme défaillance en particulier une dégradation provisoire des temps de réponse. Certaines fonctions fournies pourront être stoppées ou retirées si besoin sans compensation ou indemnisation. Nous nous réservons en outre la faculté d’arbitrer d’éventuels conflits entre Utilisateurs, et de mettre en œuvre des actions permettant de les résoudre. H2H mobility se dégage de toute responsabilité dans les actions, échanges, et interactions pouvant avoir lieu entre ou avec d’autres Utilisateurs.</p><h3>2.5 – Vie privée et protection des données</h3><p>H2H mobility s’engage à protéger les données à caractère personnel confiées par l’Utilisateur lors de son inscription. Le fichier comportant les données à caractère personnel des Utilisateurs du service H2H mobility a fait l’objet d’une déclaration auprès de la Commission Nationale de l’Informatique et des Libertés (CNIL) sous le numéro 1651043. <br/>Conformément aux dispositions de la loi n° 78-17 du 6 janvier 1978 telle que modifiée par la loi n° 2004-801 du 6 août 2004 dite “Informatique et Libertés”, sous réserve de justifier de son identité, l’Utilisateur dispose du droit de demander à ce que les données à caractère personnel le concernant soient rectifiées, complétées, mises à jour, verrouillées ou effacées si ces données sont inexactes, incomplètes, équivoques, périmées, ou si la collecte, l’utilisation, la communication ou la conservation de ces données est interdite. <br/>Il dispose également du droit de s’opposer, pour des motifs légitimes, à ce que des données à caractère personnel le concernant fassent l’objet d’un traitement. Une telle opposition rendra toutefois impossible l’utilisation du service fourni par H2H mobility. <br/>L’Utilisateur peut exercer ces droits en envoyant un courriel accompagné d’un justificatif d’identité à l’adresse suivante : contact@h2h-mobility.com.<br/>Le responsable de la collecte et du traitement de ces données est la société H2H mobility. Ces données ne seront utilisées que pour les besoins de l’utilisation du Service et ne seront pas communiquées à des tiers sans autorisation préalable. <br/>Toutes les données collectées par H2H mobility dans le cadre de l’utilisation du Service peuvent être utilisées par H2H mobility pour adapter les expériences d’utilisation.</p><h2>3. Contenus Utilisateurs</h2><p>Concernant les contenus que l’Utilisateur renseigne au sein de l’application, quels qu’ils soient, H2H mobility déclare n’exercer aucun droit ni responsabilité dessus. Le contenu reste la propriété de l’Utilisateur, qui bénéficie des dispositions de la loi Informatique et libertés s’agissant des conditions d’utilisation, du droit d’accès, de suppression et de rectification des informations le concernant. L’Utilisateur peut mettre à jour les informations à sa convenance. Cependant, au cas où H2H mobility considèrerait que ce contenu partagé à travers l’application et les Services soit sentencieux, ou puisse nuire à autrui ou ne serait pas conforme aux bonnes mœurs, H2H mobility  se réserve la faculté de rejeter ou de supprimer lesdites informations ou ladite mise à jour. <br/>L’Utilisateur reconnaît ne pas utiliser l’application et ne pas poster de contenu : dans le but de nuire à des personnes ou animaux ; qui pourrait leur causer des risques de dommage physique ou moral, des risques mortels ; à des fins de harcèlement physique ou moral ; qui pourrait nuire à des enfants, quel que soit leur âge ; qui aurait des connotations racistes ou discriminantes ; dans le but d’humilier ; qui soit illégal ; qui viserait à des malversations, à des tentatives d’intrusion de lieu physiques tels que bâtiment, habitation, site, applications ou plateforme web, mobile ou digitale quels qu’ils soient.  <br/>L’Utilisateur confirme : ne pas utiliser l’application pour tenter de récupérer ou soutirer des informations qui pourraient servir, à des fins de nuire ; ne pas fournir de contenu illégal, erroné ou sur lequel vous n’avez pas les droits de publication ; ne pas  fournir de contenu dans le but de désinformer. L’Utilisateur confirme ne pas tenter d’interférer avec d’autres utilisateurs du Service, et sans limitation de perturber le flux normal d’interaction à travers l’application, ne pas utiliser la plateforme et Services à des fins commerciales ou de distribution, de publicité ou de promotion, à des fins humanitaires, sociales ou associatives, pour des pétitions ou véhiculer de l’information, ou tout mécanisme viral, sans autorisation expresse de  H2H mobility. L’Utilisateur confirme que  tout contenu Utilisateur posté à travers les Services ne violent en aucune façon les droits de tout individu ou tierce partie, incluant sans limitation tout Droit de propriété intellectuelle ou tout autre droit de propriété et de confidentialité.<br/>H2H mobility se dégage de toute responsabilité et de tout lien avec le contenu qu’un Utilisateur pourrait poster via la plateforme. L’Utilisateur est seul responsable du contenu que fourni, par lui ou tout tiers, dès lors que ce contenu figure sur son compte utilisateur ou profil. <br/>L’Utilisateur confirme  et accepte le fait qu’il pourra être exposé à du contenu inapproprié, notamment pour les enfants, et confirme que H2H mobility ne sera en aucun cas responsable des dommages qui pourraient être occasionnés par ce contenu.</p><h2>4. Droits de Propriétés</h2><p>Le Service et tout matériel contenu et transitant sur la plateforme, telles que sans limitation,  l’application, les sources et programmes compilés, les images, les textes, les graphiques, les illustrations, les logos, les photographies, les vidéos, les fichiers audio, la musique, et les données et contenu des autres Utilisateurs, et tous les Droits de propriété intellectuelle qui leurs sont rattachés, sont la propriété exclusive de H2H mobility. L’Utilisateur ne pourra avoir aucun droit ni créer de licence relative à cette propriété intellectuelle ; il ne pourra vendre, louer, modifier, distribuer, copier, reproduire, plagier, transmettre, adapter, éditer d’application et Services similaires, ni utiliser le contenu à quelle fin que ce soit sans l’autorisation de H2H mobility.<br/>L’Utilisateur aura la possibilité de soumettre des commentaires sur les applications et les Services fournis par H2H mobility, et de proposer des améliorations ou de nouvelles fonctionnalités qui lui semblent utiles (« vos idées »). En soumettant ses idées, l’Utilisateur accepte que ces divulgations soient faites à titre gratuit, et que H2H mobility puisse les utiliser sans aucune contrepartie ni aucune limitation, et ne place H2H mobility sous aucune obligation financière ou légale. <br/>H2H mobility reste libre d’utiliser ces idées sans aucune compensation, et peut disposer de ces idées et éventuellement les partager sans être lié par aucune clause de confidentialité.</p><h2>5. Service gratuit feelsafe</h2><p>H2H mobility fournit aux Utilisateurs par défaut une version gratuite de l’application feelsafe, comportant certaines limitations ou variantes par rapport à la version premium. La version gratuite feelsafe permet à un Référent de suivre au maximum 2 Protégés. Chaque Protégé ne peut être suivi que par un seul Référent. La version gratuite feelsafe inclut également un bandeau  publicitaire. H2H mobility se donne le droit de modifier le périmètre et les conditions de gratuité de cette version si elle le juge nécessaire. L’Utilisateur dans ce cas sera tenu informé si des modifications éventuelles devaient impliquer un coût non prévu par l’Utilisateur. H2H mobility se réserve le droit d’inclure de la publicité additionnelle dans ses Applications et sur le Site. Il peut s’agir de tout format de publicité utilisé sur Internet et sur mobile, tel que (sans limitation) bannières, fichiers audio, publicité texte et mots clés, interstitiels, films, animations, etc.</p><h2>6. Service Premium feelsafe </h2><p>H2H mobility propose également aux Utilisateurs une version premium de l’application feelsafe, à travers l’activation de Services (mode de souscription via un abonnement mensuel ou annuel). La version feelsafe premium n’inclut pas de publicité et ne limite pas le nombre de Protégés suivis par un Référent, ni le nombre de Référents pouvant être connectés et reliés à un Protégé. Il est possible de passer de la version gratuite à la version premium à travers la même application en activant les services payants souhaités.</p><h3>6.1 Politique tarifaire</h3><p>En cas de souscription à la version feelsafe premium, l’Utilisateur accepte le tarif et les conditions de paiement, qui pourront changer et évoluer dans le temps si H2H mobility le jugeait opportun. Egalement de nouveaux services payants pourront être proposés en complément des services déjà proposés. L’Utilisateur sera tenu informé de ces adaptations, dès lors qu’elles impliqueraient une limitation ou modification des fonctionnalités et services proposés, une modification du tarif de l’abonnement aux Services feelsafe ou des conditions de paiement. Ces changements ne deviendront effectifs qu’après notification, comme précisé ci-après.</p><h3>6.2 – Prix et conditions tarifaires</h3><p>Tout au Service premium feelsafe est payable dés la souscription. Puis à chaque date de renouvellement de l’abonnement (mensuel ou annuel). Il est possible de résilier la souscription à des Services à tout moment. Dans ce cas, les prélèvements s’arrêteront automatiquement à la fin de la dernière période de souscription. Les Services fournis par H2H mobility seront valides jusqu’à la fin de la période de souscription pour laquelle l’Utilisateur a été débité. H2H mobility n’est en aucun cas responsable des dépenses annexes qui pourraient être occasionnées lors du règlement des Services H2H mobility en accord avec les conditions tarifaires, tels que dépassement bancaire, dépassement de limite autorisé sur carte bancaire,…). En fournissant ses coordonnées bancaires ou autre méthode de paiement, il autorise H2H mobility à débiter son compte bancaire des sommes dues, dans le cas où il souscrirait à des Services payants, et ce à chaque période de renouvellement comme indiqué ci-dessus. Ceci jusqu’à ce que son compte feelsafe soit résilié par lui ou par H2H mobility.</p><h3>6.3 – Résiliation</h3><p>L’Utilisateur peut demander la résiliation de son compte Utilisateur à tout moment  (incluant la suppression de ses données à caractère personnel détenues par H2H mobility), sans devoir justifier d’un motif. Pour cela,  il lui suffit d’envoyer un mail à contact@h2h-mobility.com. <br/>ATTENTION : A réception de la demande de résiliation, aucun paiement ou remboursement ne pourra plus intervenir. Au cas où l’Utilisateur aurait souscrit à des services premium, H2H mobility ne remboursera pas le montant versé pour l’année en cours mais annulera les prélèvements futurs. De même H2H mobility ne remboursera pas dans le cas où l’application et les Services fournis ne sont pas utilisés pendant une certaine période, quelle qu’en soit la raison. H2H mobility pourra décider de suspendre ou résilier un compte Utilisateur, sans notification préalable, sans devoir donner de motifs, ni préavis, ni formalités, ni indemnités au profit de l’Utilisateur en cas de manquement aux présentes CGU. De plus, H2H mobility se réserve le droit de prendre toutes les mesures nécessaires, y compris la résiliation d’un compte Utilisateur dans le cas d’une décision judiciaire l’y contraignant, d’événements de force majeure, ou encore en cas de suspicion sérieuse de fraude. Dans ce dernier cas, c’est à l’Utilisateur qu’il incombera de fournir les preuves attestant de sa bonne foi et de l’absence de fraude. La fraude ou le non respect de ces CGU pourront donner lieu à des poursuites judiciaires. Dans tous les cas, H2H mobility n’aura pas à verser d’indemnités ni à solder le Compte Utilisateur concerné. Y compris après la résiliation, l’Utilisateur s’engage à respecter ses engagements en vertu des présentes CGU.</p><h3>6.4 – Modes et conditions de paiement</h3><p>L’Utilisateur s’engage à fournir les informations exactes permettant à la transaction d’aboutir, de payer les services au prix indiqué, et de payer toute charge qui lui incomberait, relativement à son mode de paiement, taxes ou autres frais additionnels.</p><h2>7. Conseils fournis et recommandations</h2><p>Les conseils et informations fournies par H2H mobility doivent être pris comme tels, mais ne constituent en rien des recommandations professionnelles. L’Utilisateur privilégiera dans tous les cas, les sources d’informations notoirement reconnues.</p><h2>8. Liens vers des parties tierces</h2><p>L’application feelsafe, principalement la version gratuite, peut contenir des liens vers d’autres sites web, des publicités, des services, des contenus, des offres spéciales, ou d’autres références à des événements, des activités qui ne sont pas gérées ou contrôlées par H2H mobility. H2H mobility n’est en aucune mesure responsable des informations et contenus fournis par les parties tierces, leurs produits, services ou matériel. L’accès à une partie tierce par un lien figurant sur l’application feelsafe est sous l’entière responsabilité de l’Utilisateur, qui décharge ainsi totalement H2H mobility de toute responsabilité de ce qui pourrait subvenir à partir du moment où il accède à ces sites, services ou contenus. Plus largement H2H mobility n’est en aucun cas lié à tout engagement ou acceptation de termes et conditions qui pourrait lier l’Utilisateur à une partie tierce. Il reconnait que H2H mobility ne peut être tenu responsable de toute perte, vol, ou dégât de toute sorte qui pourrait subvenir suite à ses échanges et accords faits avec un annonceur.</p><h2>9. Indemnités</h2><p>L’Utilisateur accepte de dégager de toute responsabilité H2H mobility, ses agences et filiales éventuelles, son ou ses gérants, dirigeants, employés et autres partenaires pour tout dommage, réclamation, perte, coût, dette, frais  qui pourraient subvenir de : (i) son accès aux Services H2H mobility et à leurs utilisations, incluant les données et autres contenus transmis ou reçus par lui; (ii) toute violation à un ou plusieurs clauses de cet accord, incluant  sans limitation une rupture à l’une des garanties  ci-dessus ; (iii) toute violation aux droits de parties tierces, incluant sans limitation le droit à la vie privée ou les droits de propriété intellectuelle ; (iv) toute violation à toute loi applicable, règle ou réglementation en vigueur ; (v) toute plainte ou dégât qui pourrait subvenir et être le résultat de contenus fournis ou soumis par lui via son compte utilisateur ; (vi) ou de toute autre partie accédant et utilisant les Services avec son identifiant utilisateur, mot de passe ou autre code de sécurité approprié.  </p><h2>10. Absence de garanties</h2><p>Le Service est fourni tel quel, et les fonctionnalités de bases fournies sont standards à l’application. Son utilisation est à l’entière responsabilité de l’Utilisateur et n’est fourni sans aucune garantie. H2H mobility ne peut garantir un fonctionnement optimal, fiable et correct et des imprécisions ou défaillances peuvent apparaitre. Ceci notamment dû au fait que la plateforme utilise des services tiers qui peuvent avoir des défaillances que H2H mobility ne contrôle pas. H2H mobility ne peut garantir que le Service remplira les attentes de l’Utilisateur, qu’il sera toujours disponible n’importe où et n’importe quand, qu’il n’y aura pas d’interruption ou de faille de sécurité. Les performances de l’application peuvent varier en fonction des endroits. H2H mobility ne peut garantir que les problèmes ou défaillances seront résolues, et se désengage de toutes les conséquences que ces défaillances pourraient avoir sur les utilisateurs du Service ou sur des tierces personnes. H2H mobility ne peut garantir que le Service et application ne seront pas porteur de virus ou autre composant dangereux. Tout contenu téléchargé ou obtenu à travers l’utilisation de notre Service est aux seuls risques et responsabilités de l’Utilisateur, qui sera seul tenu responsable des dégâts éventuellement occasionnés sur son mobile, ordinateur, tablette, ou tout autre support ou sur les données qui seraient corrompues ou perdues à cause de ces téléchargement ou de l’utilisation du Service.  <br/>H2H mobility ne garantit ni n’endosse aucune responsabilité relative à tout produit ou service offert ou proposé via une publicité par une tierce partie via les Service et plateforme, et H2H mobility ne prendra en aucun cas partie entre l’Utilisateur et cette tierce partie dans le cas d’un différent, d’un litige ou d’une transaction.</p><h2>11. Limitation des responsabilités</h2><p>Dans toute la mesure permise par la Loi et la législation, H2H mobility ainsi que ses gérants, dirigeants, employés, fournisseurs, partenaires ne seront en aucun cas responsables de tout dommage direct, indirect, accidentel, exceptionnel, collatéral, incluant sans limitation des dommages relatifs aux pertes et profits, à la réputation, à des pertes de données ou autres pertes tangibles ou intangibles liés à l’utilisation ou l’impossibilité d’utiliser le Service.  La société H2H mobility ne sera, sous aucune circonstance, et en aucun cas, responsable des dommages, pertes ou préjudices résultant d’attaques de type Hacking, ou tout autre accès ou utilisation non autorisé, frauduleuse ou malveillante du Service, ou des comptes ou de l’information qu’ils contiennent. Dans toute la mesure permise par la loi et la législation, H2H mobility ainsi que ses gérants, dirigeants, employés, fournisseurs, partenaires ne seront  en aucun cas responsables ni ne pourront être poursuivis à la suite de (i) toute erreur, contenu incorrect ; (ii) tout préjudice ou dommage sur la propriété, de toute nature que ce soit, résultant de l’accès ou l’utilisation du Service ; (iii) tout accès non autorisé au serveur sécurisé et/ou à tout ou partie des informations personnelles qui y sont stockées ; (iv) toute interruption ou arrêt de transmission vers ou à partir du Service ; (v) tout bug, virus, cheval de Troie, ou autre mécanisme introduit par une partie tierce à travers la plateforme et/ou le Service, à l’insu de H2H mobility et de ses utilisateurs, dont le but est malveillant ou à objectif frauduleux ; (vi) toute erreur ou omission de contenu, de la perte ou dommage de contenu posté et mis à disposition de quelque manière que ce soit à travers le Service ; (vii) propos diffamants ou blessants, ou illégal envers un utilisateur ou autre personne, qui serait tenu par une partie tierce ou tierce personne. H2H mobility ainsi que ses gérants, dirigeants, employés, fournisseurs, partenaires ne pourront être en aucun cas redevables d’aucune plainte déposée à leur encontre pour les cas évoqués ou tout autre cas préjudiciable pour l’utilisateur ou tierce personne, ou bien matériel et immatériel, et ne pourra accepter à sa seule discrétion d’un dédommagement qui ne sera pas supérieur aux sommes déjà versées à H2H mobility par la personne impactée par le préjudice. Cette limitation de responsabilité constitue un élément essentiel des présentes CGU ; l’Utilisateur reconnaît en avoir pris l’entière mesure et y adhérer pleinement.<br/>En cas de litige avec H2H mobility, l’Utilisateur devra préalablement contacter H2H mobility via l’adresse email contact@h2h-mobility.com, afin de tenter de résoudre le litige de manière amiable.</p><h2>12. Général</h2><h3>12.1 – Transfert</h3><p>Cet accord, et les droits ou conditions qui y sont consentis, ne peuvent être transférés ou cédés par l’Utilisateur, mais peuvent être transférés ou cédés sans restriction par H2H mobility. Toute tentative de transfert ou de cession en violation à cet accord serait nulle et  non avenue.</p> <h3>12.2 – Procédure de notification et changements de l’Accord</h3> <p> H2H mobility est susceptible d’envoyer des notifications, ces notifications pouvant être exigées par la loi ou pour des besoins marketings ou commerciaux. Ces notifications peuvent être par exemple envoyées par mail, ou sous forme de communication à travers le site web. H2H mobility se réserve le droit de déterminer la forme et les moyens de fournir des notifications à ses Utilisateurs, en considérant les options éventuelles de notification que l’Utilisateur pourrait ne pas souhaiter. <br/>H2H mobility n’est pas responsable du mécanisme automatique de filtre que l’Utilisateur ou son fournisseur d’accès (FAI) pourrait appliquer sur les notifications de mail envoyées à l’adresse email fournie.</p><h3>12.3 – Changement des CGU</h3><p>H2H mobility peut, à sa seule discrétion, modifier ou mettre à jour les présentes CGU à tout moment. L’Utilisateur est invité à revoir ces CGU régulièrement. Lorsque ces CGU seront mise à jour, pour des raisons pratiques, figurera la date de ‘dernière mise à jour’ en haut de la page. L’utilisation régulière du Service après modification de l’Accord signifie l’acceptation des modifications et des nouveaux termes éventuellement inclus dans l’Accord. Au cas où l’Utilisateur serait en désaccord avec certains termes modifiés ou ajoutés, il s’engage à ne plus accéder ou utiliser (ou continuer d’accéder) au Service. </p><h3>12.4 – Globalité de l’Accord / Dissociabilité</h3><p>Au cas où une clause ou partie de cet Accord devait être jugé invalide par une cour compétente et via une décision de justice, cela n’affectera aucunement le reste de l’Accord qui restera totalement valide.</p><h3>12.5 – Contact</h3><p>H2H mobility peut être contacté à l’adresse suivante : contact@h2h-mobility.com pour toute question relative à cet Accord.</p><h2>13. Responsabilités</h2> <p>H2H mobility ne saurait être tenu responsable en cas de mauvais fonctionnement du Service, quelle qu’en soit la cause.  L’Utilisateur devra disposer des compétences, des matériels et des logiciels requis pour l’utilisation d’Internet sur un ordinateur ou sur son terminal mobile. <br/>L’Utilisateur accepte en utilisant le Service tous les risques et les caractéristiques propres à l’utilisation de terminaux mobiles et Internet, en particulier les possibles délais de transmission, les dysfonctionnements techniques et les risques de piratage. Enfin, l’Utilisateur est conscient et informé des éventuels virus et autres programmes malfaisants pouvant circuler sur Internet, et il lui appartient de prendre toutes les mesures pour s’en protéger. La responsabilité de H2H mobility ne pourrait en aucun cas être engagée en cas de problème résultant de l’utilisation du Service. <br/>En particulier, H2H mobility décline toute responsabilité en cas d’interruption du Service, de survenance de bugs ou d’erreurs de fonctionnement, ainsi qu’en cas de dommages, direct ou indirect, qu’elles qu’en soient les causes, origines, natures ou conséquences, provoqués à raison de l’accès de quiconque au Service et/ou de l’impossibilité d’y accéder, de même que l’utilisation du Service et/ou du crédit accordé à une quelconque information provenant directement ou indirectement de ce dernier. H2H mobility n’assume aucune responsabilité pour les dommages qui pourraient être causés au matériel informatique des Utilisateurs à la suite de l’accès au Site ou à l’Application, de l’utilisation ou du téléchargement de l’un quelconque de leurs éléments (données, textes, images, vidéos ou sons, etc.). <br/>Pour des raisons de maintenance, H2H mobility pourra interrompre le fonctionnement du Service et s’efforcera d’en avertir préalablement les Utilisateurs par le biais d’un e-mail envoyé à l’adresse électronique renseignée lors de l’inscription. H2H mobility ne saurait être tenu pour responsable du retard, de la perte ou de la mauvaise distribution d’un e-mail, ni de son envoi ou non à une adresse électronique erronée. <br/>Les informations fournies par le biais du Service le sont sous toutes réserves. <p>",nil);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.textView.attributedText = attributedString;
}

- (void)dismissCGU
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CGUaccepted" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
