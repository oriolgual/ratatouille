# frozen_string_literal: true

require 'thor'
require 'ratatouille'

module Ratatouille
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc 'import URL', 'Parses a recipe into a YAML format to be imported to Paprika'

    def import(url)
      Importer.new(url).to_yaml
    end


    desc 'import everything', 'wahevet'

    def dump
      all = [
        "http://alimentarte.net/albondigas-vegetarianas-de-lentejas-y-champinones-con-salsa-de-tomate/",
        "http://foodsfortomorrow.com/recetas/flammkuchen-con-heura/",
        "http://foodsfortomorrow.com/recetas/pizza-la-huerta-queso-vegano-chilli/",
        "http://paraisovegetal-bruma.blogspot.com/2013/11/turron-de-chocolate-crujiente-suchard.html",
        "http://www.cocinarvegano.com/numeros-e-aditivos-alimentarios-veganos-aptos/",
        "http://www.creativegan.net/archives/omurice-tortilla-con-arroz/",
        "http://www.ifeelvegan.net/hummus-de-chocolate/",
        "http://www.midietavegana.es/curry-de-mango-y-garbanzos-dulce-picante/",
        "http://www.midietavegana.es/pastelitos-de-patata-rellenos-veganos/",
        "http://www.midietavegana.es/patatas-en-salsa-verde-con-tofu/",
        "http://www.vegetarianismo.net/recetas/bizcocho-vegano-chocolate.html",
        "https://beginveganbegun.es/2012/04/26/aros-de-cebolla-al-horno/",
        "https://beginveganbegun.es/2013/05/21/risotto-de-champinones-y-zanahoria/",
        "https://beginveganbegun.es/2014/07/19/risotto-de-calabacin-vegano-yogur/",
        "https://beginveganbegun.es/2015/06/29/tortilla-de-patata-vegana-con-pimientos/",
        "https://beginveganbegun.es/2016/09/26/dhal-de-lentejas-rojas-vegano/",
        "https://beginveganbegun.es/2016/10/24/tostas-de-sobrasada-vegana-y-queso-de-anacardo/",
        "https://beginveganbegun.es/2016/10/31/crispy-vegan-burger/",
        "https://beginveganbegun.es/2017/01/23/arepas-veganas-reina-pepiada/",
        "https://beginveganbegun.es/2017/02/27/chili-vegano/",
        "https://beginveganbegun.es/2017/05/15/pasta-proteica-con-bolonesa-de-lentejas/",
        "https://beginveganbegun.es/2017/10/30/chips-de-boniato-con-salsa-ranch/",
        "https://beginveganbegun.es/2018/04/16/albondigas-veganas-de-soja-texturizada/",
        "https://beginveganbegun.es/2018/07/09/sandwich-100-vegetal-de-tofu-y-queso-de-anacardos/",
        "https://beginveganbegun.es/2018/07/24/chana-masala-curry-de-garbanzos/",
        "https://beginveganbegun.es/2018/11/06/garbanzos-con-espinacas-receta-vegana/",
        "https://beginveganbegun.es/2018/12/03/pasteles-de-tofu-con-setas-y-esparragos/",
        "https://beginveganbegun.es/2019/02/04/sandwiches-veganos-rebozados/",
        "https://beginveganbegun.es/2020/04/11/barra-prenada-vegana/",
        "https://beginveganbegun.es/2020/04/22/pizza-proteica-vegana-al-cheddar-casero/",
        "https://beginveganbegun.es/2020/04/27/pan-naan-vegano-pan-en-sarten-sin-horno/",
        "https://beginveganbegun.es/2020/05/04/muffins-de-brocoli/",
        "https://blog.elamasadero.com/chapata-julio-pena/",
        "https://blog.elamasadero.com/coca-de-aceite-se-vislumbra-la-primavera/",
        "https://blog.elamasadero.com/hablan-los-clientes/panecillos-integrales-para-hamburguesas-de-monica-vernet/",
        "https://blog.elamasadero.com/hogaza-con-harina-de-garbanzos/",
        "https://blog.elamasadero.com/pan-de-chocolate-de-samuel-granado/",
        "https://blog.elamasadero.com/pan-de-cristal/",
        "https://blog.elamasadero.com/recetas_pan_casero/receta-de-pan-indio-naan-en-sarten/",
        "https://blogosferathermomix.es/thermomixporelmundo/2011/09/23/falafel-de-garbanzos-receta-libanesa-con-thermomix/",
        "https://cocinina.com/2017/01/24/tortitas-faciles/",
        "https://cocinina.com/2018/01/26/crema-de-chocolate-y-garbanzos/",
        "https://cocinina.com/2018/07/11/crema-de-zanahorias-y-lenteja-roja/",
        "https://cocinina.com/2018/07/28/polos-de-chocolate-cremosos/",
        "https://cocinina.com/2018/10/19/albondigas-de-avena-y-soja/",
        "https://cocinina.com/2019/09/13/tortitas-faciles-2-0/",
        "https://comeviveviaja.com/muhammara-sin-gluten-una-deliciosa-crema-de-pimientos-y-nueces/",
        "https://comidasegipcias.com/aish-baladi/",
        "https://comidasegipcias.com/fufu/",
        "https://comidasegipcias.com/khubz/",
        "https://comidasegipcias.com/kousa-mahshi/",
        "https://comidasegipcias.com/yufka/",
        "https://comidasegipcias.com/zaalouk-berenjenas/",
        "https://comoservegano.com/2014/10/27/sandwich-de-no-atun/",
        "https://danzadefogones.com/albondigas-veganas/",
        "https://danzadefogones.com/aloo-gobi-matar/",
        "https://danzadefogones.com/arepas/",
        "https://danzadefogones.com/arroz-con-leche-vegano/",
        "https://danzadefogones.com/arroz-jambalaya-vegano/",
        "https://danzadefogones.com/burritos/",
        "https://danzadefogones.com/como-cocinar-mijo/",
        "https://danzadefogones.com/crema-de-cacao-y-avellanas-nocilla-o-nutella-casera/",
        "https://danzadefogones.com/crema-de-champinones/",
        "https://danzadefogones.com/curry-de-garbanzos/",
        "https://danzadefogones.com/ensalada-cobb-vegana/",
        "https://danzadefogones.com/ensalada-vegana-de-kale/",
        "https://danzadefogones.com/espaguetis-de-calabacin-con-salsa-de-aguacate/",
        "https://danzadefogones.com/espinacas-con-garbanzos/",
        "https://danzadefogones.com/goulash-vegano/",
        "https://danzadefogones.com/hamburguesas-veganas/",
        "https://danzadefogones.com/lasana-de-berenjena-vegana/",
        "https://danzadefogones.com/mousse-de-arroz-con-leche/",
        "https://danzadefogones.com/noodles-con-verduras/",
        "https://danzadefogones.com/pan-de-platano-vegano/?mc_cid=d44b2885f7",
        "https://danzadefogones.com/pancakes-veganos/",
        "https://danzadefogones.com/pastel-carne-vegano/",
        "https://danzadefogones.com/pesto-de-kale-vegano/",
        "https://danzadefogones.com/pho-vegano/",
        "https://danzadefogones.com/pudin-vegano-de-chocolate/",
        "https://danzadefogones.com/queso-crema-vegano/print/15767/",
        "https://danzadefogones.com/queso-vegano/",
        "https://danzadefogones.com/rollos-tempeh-marinado/",
        "https://danzadefogones.com/sopa-miso-vegana/",
        "https://danzadefogones.com/tofu-kung-pao/",
        "https://delantaldealces.com/hamburguesa-azukis-japonesa/",
        "https://elavegan.com/vegan-deep-dish-pizza-gluten-free-recipe/",
        "https://elpetitchef.com/recetas/dhal-de-lentejas-especiado",
        "https://ideavegana.com/kebab-vegano-soja-picante/",
        "https://invitadoinvierno.com/como-preparar-cafe-en-frio-o-cold-brew/",
        "https://invitadoinvierno.com/minihamburguesas-con-pan-de-cerveza-y-avena/",
        "https://invitadoinvierno.com/panecillos-hamburguesa-integrales/",
        "https://juanllorca.com/recetas/cookies-brownie-sin-azucar-y-sin-gluten/",
        "https://minimalistbaker.com/cheesy-vegan-spinach-artichoke-dip/",
        "https://molsa.bio/recepta-polos-de-matcha-latte/",
        "https://mommyshomecooking.com/masa-para-pizza-de-coliflor-sin-huevo/",
        "https://recetasveganas.net/recipes/bowl-curry-picante-heura-verduras-cacahuetes",
        "https://recetasveganas.net/recipes/pan-hindu-naan-sin-horno-sarten-vegano",
        "https://sanofuertefeliz.com/nocilla-casera-sin-azucar-y-sin-aceite-de-palma/",
        "https://umamiplantbased.com/next-level-vegan-mozzarella/",
        "https://umamiplantbased.com/spicy-tahini-udon-noodles/",
        "https://umamiplantbased.com/vegan-carrot-cake/",
        "https://umamiplantbased.com/vegan-chocolate-cheesecake/",
        "https://umamiplantbased.com/vegan-thai-green-curry/",
        "https://umamiplantbased.com/vegan-tuna-cheese-melt/",
        "https://unareceta.com/yuca-al-horno/",
        "https://veganfitstore.es/estofado-vegano-ultraproteico-y-saciante/",
        "https://veganfitstore.es/lasana-vegana-sin-gluten-y-rica-en-proteinas-receta/",
        "https://veganyackattack.com/2013/09/30/mozzarella-mac-deep-dish-pizza/",
        "https://veggieboop.com/index.php/2016/10/11/tortilla-de-patatas-sin-huevo-vegana/",
        "https://veggisima.com/sin-huevo-revueltos/",
        "https://www.bakerita.com/chocolate-chip-vegan-banana-bread/",
        "https://www.botanical-online.com/cocinarlegumbres.htm",
        "https://www.botanical-online.com/legumbres-como-no-den-gases.htm",
        "https://www.centroaleris.com/aleris-nou/berenjenas-con-tofu-y-miso-receta-aleris/",
        "https://www.centroaleris.com/aleris-nou/trinxat-de-la-cerdanya-receta-aleris/",
        "https://www.cocinasinreceta.com/receta/albondigas-de-garbanzos-y-avena/",
        "https://www.cocinasinreceta.com/receta/enchiladas-de-lentejas-con-arroz/",
        "https://www.cocinasinreceta.com/tecnicas/hackea-tu-masa-de-pizza-con-garbanzos/",
        "https://www.condospalillos.com/blog/2015/6/16/miso-ramen-vegano",
        "https://www.creativegan.net/archives/crema-de-garbanzos-y-coliflor-tostados/",
        "https://www.creativegan.net/archives/redondo-de-tofu-relleno/",
        "https://www.creativegan.net/archives/turron-de-chocolate-crujiente/",
        "https://www.cuerpomente.com/blogs/gastronomia-consciente/recetas-hummus-originales_1425",
        "https://www.cuerpomente.com/blogs/gastronomia-consciente/tortitas-veganas-receta-para-todas_859",
        "https://www.cuerpomente.com/recetas-veganas/platos/lentejas-pardinas-picadillo-verduras_2773",
        "https://www.cuerpomente.com/recetas-veganas/platos/sopa-lentejas-curcuma_1654",
        "https://www.diamundialveganismo.org/2017/11/12/crema-de-calabaza-otonal/",
        "https://www.dimensionvegana.com/sandwich-de-atun-vegano/",
        "https://www.dimequecomes.com/2013/10/hamburguesas-de-lenteja-roja.html",
        "https://www.elgranero.com/saborear/receta-mousse-de-chocolate-y-tofu/",
        "https://www.gastronomiavegana.org/trucos/como-sustituir-el-huevo/",
        "https://www.gastronomiavegana.org/tutoriales/como-hacer-tortillas-de-patatas-sin-huevos/",
        "https://www.hazteveg.com/receta/7882/an",
        "https://www.hsnstore.com/blog/recetas-veganas-faciles/",
        "https://www.hsnstore.com/blog/yogur-proteico-vegano/",
        "https://www.ketoconnect.net/wprm_print/18764",
        "https://www.midietavegana.es/gofres-de-tofu-fake-egg-waffles/",
        "https://www.midietavegana.es/tortilla-de-patatas-y-tofu-sin-harina/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/crema-de-avellana-y-chocolate/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/crema-de-garbanzos/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/hummus/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/potaje-de-lentejas-1/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/queso-de-soja-a-las-hierbas-casero-asado/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/ratatouille-2/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/risotto-de-rucula/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/risotto-de-setas-con-parmesano/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/salsa-de-tomate/",
        "https://www.monsieur-cuisine.com/es/recetas/detalle/tabule-a-la-guindilla/",
        "https://www.mydarlingvegan.com/vegan-huevos-rancheros/",
        "https://www.nutricionesencial.es/2019/02/brownie-crudivegano.html/",
        "https://www.recetasdeescandalo.com/potaje-de-garbanzos-con-acelgas-un-platazo-saludable-de-cuchara/",
        "https://www.recetasgratis.net/receta-de-atun-vegano-con-soja-texturizada-71886.html",
        "https://www.thefullhelping.com/go-to-cashew-cheese-recipe/",
        "https://www.veganevibes.de/veganer-fisch-burger-mit-cashew-remoulade/",
        "https://www.veganricha.com/2019/12/tofu-and-cauliflower-in-kolhapuri-sauce.html",
        "https://www.veggiessavetheday.com/tofu-scramble-tater-tot-casserole-2/",
        "https://www.velocidadcuchara.com/falafel-con-thermomix-las-croquetas-de-garbanzos/",
        "https://www.veritas.es/ca/arros-integral-cremos-llombarda/",
        "https://www.veritas.es/ca/crema-de-llenties-vermelles/",
        "https://www.veritas.es/ca/seitan-amb-verdures-salsa-de-cervesa/",
        "https://www.veritas.es/ca/llenties-amb-carxofes/"
      ]

      all = ["http://foodsfortomorrow.com/recetas/flammkuchen-con-heura/", "http://foodsfortomorrow.com/recetas/pizza-la-huerta-queso-vegano-chilli/", "http://paraisovegetal-bruma.blogspot.com/2013/11/turron-de-chocolate-crujiente-suchard.html", "http://www.cocinarvegano.com/numeros-e-aditivos-alimentarios-veganos-aptos/", "http://www.creativegan.net/archives/omurice-tortilla-con-arroz/", "http://www.vegetarianismo.net/recetas/bizcocho-vegano-chocolate.html", "https://blog.elamasadero.com/chapata-julio-pena/", "https://blog.elamasadero.com/coca-de-aceite-se-vislumbra-la-primavera/", "https://blog.elamasadero.com/hablan-los-clientes/panecillos-integrales-para-hamburguesas-de-monica-vernet/", "https://blog.elamasadero.com/hogaza-con-harina-de-garbanzos/", "https://blog.elamasadero.com/pan-de-chocolate-de-samuel-granado/", "https://blog.elamasadero.com/pan-de-cristal/", "https://blog.elamasadero.com/recetas_pan_casero/receta-de-pan-indio-naan-en-sarten/", "https://comoservegano.com/2014/10/27/sandwich-de-no-atun/", "https://elpetitchef.com/recetas/dhal-de-lentejas-especiado", "https://ideavegana.com/kebab-vegano-soja-picante/", "https://juanllorca.com/recetas/cookies-brownie-sin-azucar-y-sin-gluten/", "https://molsa.bio/recepta-polos-de-matcha-latte/", "https://sanofuertefeliz.com/nocilla-casera-sin-azucar-y-sin-aceite-de-palma/", "https://umamiplantbased.com/next-level-vegan-mozzarella/", "https://umamiplantbased.com/spicy-tahini-udon-noodles/", "https://umamiplantbased.com/vegan-carrot-cake/", "https://umamiplantbased.com/vegan-chocolate-cheesecake/", "https://umamiplantbased.com/vegan-thai-green-curry/", "https://umamiplantbased.com/vegan-tuna-cheese-melt/", "https://veganfitstore.es/estofado-vegano-ultraproteico-y-saciante/", "https://veganfitstore.es/lasana-vegana-sin-gluten-y-rica-en-proteinas-receta/", "https://veggieboop.com/index.php/2016/10/11/tortilla-de-patatas-sin-huevo-vegana/", "https://www.botanical-online.com/cocinarlegumbres.htm", "https://www.botanical-online.com/legumbres-como-no-den-gases.htm", "https://www.cocinasinreceta.com/receta/albondigas-de-garbanzos-y-avena/", "https://www.cocinasinreceta.com/receta/enchiladas-de-lentejas-con-arroz/", "https://www.cocinasinreceta.com/tecnicas/hackea-tu-masa-de-pizza-con-garbanzos/", "https://www.condospalillos.com/blog/2015/6/16/miso-ramen-vegano", "https://www.creativegan.net/archives/crema-de-garbanzos-y-coliflor-tostados/", "https://www.creativegan.net/archives/redondo-de-tofu-relleno/", "https://www.creativegan.net/archives/turron-de-chocolate-crujiente/", "https://www.cuerpomente.com/blogs/gastronomia-consciente/recetas-hummus-originales_1425", "https://www.cuerpomente.com/blogs/gastronomia-consciente/tortitas-veganas-receta-para-todas_859", "https://www.cuerpomente.com/recetas-veganas/platos/lentejas-pardinas-picadillo-verduras_2773", "https://www.cuerpomente.com/recetas-veganas/platos/sopa-lentejas-curcuma_1654", "https://www.diamundialveganismo.org/2017/11/12/crema-de-calabaza-otonal/", "https://www.dimensionvegana.com/sandwich-de-atun-vegano/", "https://www.dimequecomes.com/2013/10/hamburguesas-de-lenteja-roja.html", "https://www.exploratorium.edu/cooking/convert/measurements.html", "https://www.gastronomiavegana.org/trucos/como-sustituir-el-huevo/", "https://www.gastronomiavegana.org/tutoriales/como-hacer-tortillas-de-patatas-sin-huevos/", "https://www.hsnstore.com/blog/recetas-veganas-faciles/", "https://www.monsieur-cuisine.com/es/recetas/detalle/crema-de-avellana-y-chocolate/", "https://www.monsieur-cuisine.com/es/recetas/detalle/crema-de-garbanzos/", "https://www.monsieur-cuisine.com/es/recetas/detalle/hummus/", "https://www.monsieur-cuisine.com/es/recetas/detalle/potaje-de-lentejas-1/", "https://www.monsieur-cuisine.com/es/recetas/detalle/queso-de-soja-a-las-hierbas-casero-asado/", "https://www.monsieur-cuisine.com/es/recetas/detalle/ratatouille-2/", "https://www.monsieur-cuisine.com/es/recetas/detalle/risotto-de-rucula/", "https://www.monsieur-cuisine.com/es/recetas/detalle/risotto-de-setas-con-parmesano/", "https://www.monsieur-cuisine.com/es/recetas/detalle/salsa-de-tomate/", "https://www.monsieur-cuisine.com/es/recetas/detalle/tabule-a-la-guindilla/", "https://www.mydarlingvegan.com/vegan-huevos-rancheros/", "https://www.nutricionesencial.es/2019/02/brownie-crudivegano.html/"]

      failed=[]
      all.each do |url|
        begin
          puts "Processing #{url}"
          failed << url unless Importer.new(url).to_yaml
        rescue
          puts "Import crashed"
          failed << url
        end
      end

      puts failed
      puts failed.inspect
    end
  end
end
