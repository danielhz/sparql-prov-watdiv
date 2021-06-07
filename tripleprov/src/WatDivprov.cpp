/*
 * WatDivprov.cpp
 *
 *  Created on: Jun 03, 2021
 *      Author: Daniel Hernandez
 */

#include "WatDivprov.h"

namespace queries {
	
  WatDivprov::WatDivprov() {
    // provOutput.open(diplo::statsDir+"provOutput");
    // TODO Auto-generated constructor stub
  }

  WatDivprov::~WatDivprov() {
    // TODO Auto-generated destructor stub
  }

  void WatDivprov::mixer() {
  }


  /*
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/galuc/wsdbm/>
    SELECT ?v0 ?v2 ?v3 WHERE {
      ?v0 wsdbm:subscribes wsdbm:Website10096 .
      ?v2 sorg:caption ?v3 .
      ?v0 wsdbm:likes ?v2 .
    }
   */
  void WatDivprov::l1() {
    // Used URIs
    KEY_ID wsdbm_subscribes = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/subscribes>");
    KEY_ID wsdbm_likes = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/likes>");
    KEY_ID wsdbm_Website10096 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Website10096>");
    KEY_ID sorg_caption = diplo::KM.Get("<http://schema.org/caption>");

    // Get bindings for variable ?v0 from triple (?v0 wsdbm:subscribes wsdbm:Website10096)
    unordered_set<KEY_ID> results_v0;
    vector<unordered_set<KEY_ID>> prov_v0;
    API::GetSubjects(wsdbm_Website10096, wsdbm_subscribes, results_v0, prov_v0);

    for (auto v0 = results_v0.begin(); v0 != results_v0.end(); v0++) {
      // Get bindings for variable ?v2 from triple (?v0 wsdbm:likes ?v2)
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;

      API::GetObjects(*v0, wsdbm_likes, results_v2, prov_v2);

      if (!results_v2.empty()) {
	for (auto v2 = results_v2.begin(); v2 != results_v2.end(); v2++) {
	  // Get bindings for variable ?v3 from triple (?v2 sorg:caption ?v3)
	  unordered_set<KEY_ID> results_v3;
	  unordered_set<KEY_ID> prov_v3;

	  API::GetObjects(*v2, sorg_caption, results_v3, prov_v3);

	  if (!results_v3.empty()) {
	    cout << "Results:" << endl;
	    for (auto v3 = results_v3.begin(); v3 != results_v3.end(); v3++) {
	      cout << diplo::KM.Get(*v0) << " "
		   << diplo::KM.Get(*v2) << " "
		   << diplo::KM.Get(*v3) << endl;
	    }

	    cout << "Provenance:" << endl;
	    cout << "((";
	    for (auto p0 = prov_v0[0].begin(); p0 != prov_v0[0].end(); p0++)
	      cout << diplo::KM.Get(*p0) << " + ";
	    cout << ") X (";
	    for (auto p2 = prov_v2.begin(); p2 != prov_v2.end(); p2++)
	      cout << diplo::KM.Get(*p2) << " + ";
	    cout << ") X (";
	    for (auto p3 = prov_v3.begin(); p3 != prov_v3.end(); p3++)
	      cout << diplo::KM.Get(*p3) << " + ";
	    cout << "))" << endl;
	  }
	}
      }
    }
    ProvOut
  }

  /*
    PREFIX gn: <http://www.geonames.org/ontology#>
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/galuc/wsdbm/>
    SELECT ?v1 ?v2 WHERE {
      wsdbm:City121 gn:parentCountry ?v1 .
      ?v2 wsdbm:likes wsdbm:Product0 .
      ?v2 sorg:nationality ?v1 .
    }
   */
  void WatDivprov::l2() {
    KEY_ID wsdbm_City121 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/City121>");
    KEY_ID wsdbm_Product0 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Product0>");
    KEY_ID wsdbm_likes = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/likes>");
    KEY_ID gn_parentCountry = diplo::KM.Get("<http://www.geonames.org/ontology#parentCountry>");
    KEY_ID sorg_nationality = diplo::KM.Get("<http://schema.org/nationality>");
	
    // Get bindings for variable ?v1 from triple t1: (wsdbm:City121 gn:parentCountry ?v1)
    unordered_set<KEY_ID> results_v1;
    unordered_set<KEY_ID> prov_t1;
    API::GetObjects(wsdbm_City121, gn_parentCountry, results_v1, prov_t1);

    if (!results_v1.empty()) {
      cout << "Results:" << endl;
      for (auto v1 = results_v1.begin(); v1 != results_v1.end(); v1++) {
	// Get bindings for variable ?v1 from triple t1: (wsdbm:City121 gn:parentCountry ?v1)

	// Constraints and projections for molecule ?v2
	vector<TripleIDs> constraints_v2;
	vector<TripleIDs> projections_v2;
	constraints_v2.push_back(TripleIDs(0, wsdbm_likes, wsdbm_Product0, 0));
	constraints_v2.push_back(TripleIDs(0, sorg_nationality, *v1, 0));

	vector<vector<unordered_set<KEY_ID>>> results_v2;
	vector<vector<unordered_set<KEY_ID>>> prov_v2; 

	API::TriplePatern(constraints_v2, projections_v2, results_v2, prov_v2);
	if (!results_v2.empty()) {
	  cout << "Result:" << diplo::KM.Get(*v1) << endl;
	  cout << "Provenance:" << endl;
	  cout << "(";
	  for (auto p1 = prov_t1.begin(); p1 != prov_t1.end(); p1++)
	    cout << diplo::KM.Get(*p1) << " + ";
	  cout << ") X (" << endl;
	  API::DrisplayProvenance(prov_v2);
	  cout << ")" << endl;
	}
      }
    }
    
    ProvOut
  }
  
  /*
    PREFIX og: <http://ogp.me/ns#>
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/galuc/wsdbm/>
    SELECT ?v0 ?v2 WHERE {
      ?v0 og:tag wsdbm:Topic45 .
      ?v0 sorg:caption ?v2 .
    }
  */
  void WatDivprov::l4() {
#ifdef SHOW_STATS
    size_t is, im, imf;
#endif

    // Used URIs
    KEY_ID wsdbm_Topic45 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Topic45>");
    KEY_ID sorg_caption = diplo::KM.Get("<http://schema.org/caption>");
    KEY_ID og_tag = diplo::KM.Get("<http://ogp.me/ns#tag>");

    // Constraints for molecule ?v0
    vector<TripleIDs> constraints_v0;
    constraints_v0.push_back(TripleIDs(0, og_tag, wsdbm_Topic45, 0));

    // Projections for molecule ?v0
    vector<TripleIDs> projections_v0;
    projections_v0.push_back(TripleIDs(0, sorg_caption, 0, 0));

    // Results and provenance for molecule v0
    vector<vector<unordered_set<KEY_ID>>> results_v0;
    vector<vector<unordered_set<KEY_ID>>> prov_v0;

    // Evaluate molecule ?v0
    API::TriplePatern(constraints_v0, projections_v0, results_v0, prov_v0);

#ifdef DISPLAY_RESULTS
    API::DrisplayResults(results_v0);
    API::DrisplayProvenance(prov_v0);
#endif

#ifdef SHOW_STATS
    unordered_set<KEY_ID> ps;
    size_t rs=0;
    for (auto it_p : prov_v0) for (auto it : it_p ) for (auto it2 : it ) ps.insert(it2);
    for (auto it_p : results_v0) for (auto it : it_p ) rs+=it.size();
    PrintStats
#endif
    ProvOut
  }

  /*
    PREFIX gn: <http://www.geonames.org/ontology#>
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
    SELECT ?v0 ?v1 ?v3 WHERE {
      ?v0 sorg:jobTitle ?v1 .
      wsdbm:City199 gn:parentCountry ?v3 .
      ?v0 sorg:nationality ?v3 .
    }
  */
  void WatDivprov::l5() {
    KEY_ID wsdbm_City199 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/City199>");
    KEY_ID gn_parentCountry = diplo::KM.Get("<http://www.geonames.org/ontology#parentCountry>");
    KEY_ID sorg_nationality = diplo::KM.Get("<http://schema.org/nationality>");
    KEY_ID sorg_jobTitle = diplo::KM.Get("<http://schema.org/jobTitle>");
    
    // Get bindings for variable ?v3 from triple t2: (wsdbm:City199 gn:parentCountry ?v3)
    unordered_set<KEY_ID> results_v3;
    unordered_set<KEY_ID> prov_t2;
    API::GetObjects(wsdbm_City199, gn_parentCountry, results_v3, prov_t2);

    if (!results_v3.empty()) {
      cout << "Results:" << endl;
      for (auto v3 = results_v3.begin(); v3 != results_v3.end(); v3++) {
	// Constraints and projections for molecule ?v1
	vector<TripleIDs> constraints_v1;
	vector<TripleIDs> projections_v1;
	constraints_v1.push_back(TripleIDs(0, sorg_nationality, *v3, 0));
	projections_v1.push_back(TripleIDs(0, sorg_jobTitle, 0, 0));

	vector<vector<unordered_set<KEY_ID>>> results_v1;
	vector<vector<unordered_set<KEY_ID>>> prov_v1;

	API::TriplePatern(constraints_v1, projections_v1, results_v1, prov_v1);
	if (!results_v1.empty()) {
	  cout << "Result:" << diplo::KM.Get(*v3) << endl;
	  cout << "Provenance:" << endl;
	  cout << "(";
	  for (auto p2 = prov_t2.begin(); p2 != prov_t2.end(); p2++)
	    cout << diplo::KM.Get(*p2) << " + ";
	  cout << ") X (" << endl;
	  API::DrisplayProvenance(prov_v1);
	  cout << ")" << endl;
	}
      }
    }
  }

  /*
    PREFIX gr: <http://purl.org/goodrelations/>
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
    SELECT ?v0 ?v1 ?v3 ?v4 ?v5 ?v6 ?v7 ?v8 ?v9 WHERE {
      ?v0 gr:includes ?v1 .
      wsdbm:Retailer8811 gr:offers ?v0 .
      ?v0 gr:price ?v3 .
      ?v0 gr:serialNumber ?v4 .
      ?v0 gr:validFrom ?v5 .
      ?v0 gr:validThrough ?v6 .
      ?v0 sorg:eligibleQuantity ?v7 .
      ?v0 sorg:eligibleRegion ?v8 .
      ?v0 sorg:priceValidUntil ?v9 .
    }
   */
  void WatDivprov::s1() {
    KEY_ID wsdbm_Retailer8811 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Retailer8811>");
    KEY_ID gr_offers = diplo::KM.Get("<http://purl.org/goodrelations/offers>");
    KEY_ID gr_includes = diplo::KM.Get("<http://purl.org/goodrelations/includes>");
    KEY_ID gr_price = diplo::KM.Get("<http://purl.org/goodrelations/price>");
    KEY_ID gr_serialNumber = diplo::KM.Get("<http://purl.org/goodrelations/serialNumber>");
    KEY_ID gr_validFrom = diplo::KM.Get("<http://purl.org/goodrelations/validFrom>");
    KEY_ID gr_validThrough = diplo::KM.Get("<http://purl.org/goodrelations/validThrough>");
    KEY_ID sorg_eligibleQuantity = diplo::KM.Get("<http://schema.org/eligibleQuantity>");
    KEY_ID sorg_eligibleRegion = diplo::KM.Get("<http://schema.org/eligibleRegion>");
    KEY_ID sorg_priceValidUntil = diplo::KM.Get("<http://schema.org/priceValidUntil>");
    
    // Get bindings for variable ?v0 from triple t2: (wsdbm:Retailer8811 gr:offers ?v0)
    unordered_set<KEY_ID> results_v0;
    unordered_set<KEY_ID> prov_v0;
    API::GetObjects(wsdbm_Retailer8811, gr_offers, results_v0, prov_v0);

    if (!results_v0.empty()) {
      for (auto v0 = results_v0.begin(); v0 != results_v0.end(); v0++) {
	// Get bindings for variable ?v1 from triple (?v0 gr:includes ?v1)
	unordered_set<KEY_ID> results_v1;
	unordered_set<KEY_ID> prov_v1;
	API::GetObjects(*v0, gr_includes, results_v1, prov_v1);

	// Get bindings for variable ?v3 from triple (?v0 gr:price ?v3)
	unordered_set<KEY_ID> results_v3;
	unordered_set<KEY_ID> prov_v3;
	API::GetObjects(*v0, gr_price, results_v3, prov_v3);

	// Get bindings for variable ?v4 from triple (?v0 gr:serialNumber ?v4)
	unordered_set<KEY_ID> results_v4;
	unordered_set<KEY_ID> prov_v4;
	API::GetObjects(*v0, gr_serialNumber, results_v4, prov_v4);

	// Get bindings for variable ?v5 from triple (?v0 gr:validFrom ?v5)
	unordered_set<KEY_ID> results_v5;
	unordered_set<KEY_ID> prov_v5;
	API::GetObjects(*v0, gr_validFrom, results_v5, prov_v5);

	// Get bindings for variable ?v6 from triple (?v0 gr:validThrough ?v6)
	unordered_set<KEY_ID> results_v6;
	unordered_set<KEY_ID> prov_v6;
	API::GetObjects(*v0, gr_validThrough, results_v6, prov_v6);

	// Get bindings for variable ?v7 from triple (?v0 sorg:eligibleQuantity ?v7)
	unordered_set<KEY_ID> results_v7;
	unordered_set<KEY_ID> prov_v7;
	API::GetObjects(*v0, sorg_eligibleQuantity, results_v7, prov_v7);

	// Get bindings for variable ?v8 from triple (?v0 sorg:eligibleRegion ?v8)
	unordered_set<KEY_ID> results_v8;
	unordered_set<KEY_ID> prov_v8;
	API::GetObjects(*v0, sorg_eligibleRegion, results_v8, prov_v8);

	// Get bindings for variable ?v9 from triple (?v0 sorg:priceValidUntil ?v9)
 	unordered_set<KEY_ID> results_v9;
	unordered_set<KEY_ID> prov_v9;
	API::GetObjects(*v0, sorg_priceValidUntil, results_v9, prov_v9);
	
	if (!results_v1.empty() && !results_v3.empty() && !results_v4.empty() &&
	    !results_v5.empty() && !results_v6.empty() && !results_v7.empty() &&
	    !results_v8.empty() && !results_v9.empty()) {
	  cout << "Results for v0: " << diplo::KM.Get(*v0) << endl;
	  cout << "Results for v3: ";
	  for (auto v3 = results_v3.begin(); v3 != results_v3.end(); v3++)
	    cout << diplo::KM.Get(*v3) << " ";
	  cout << endl;
	  cout << "Results for v4: ";
	  for (auto v4 = results_v4.begin(); v4 != results_v4.end(); v4++)
	    cout << diplo::KM.Get(*v4) << " ";
	  cout << endl;
	  cout << "Results for v5: ";
	  for (auto v5 = results_v5.begin(); v5 != results_v5.end(); v5++)
	    cout << diplo::KM.Get(*v5) << " ";
	  cout << endl;
	  cout << "Results for v6: ";
	  for (auto v6 = results_v6.begin(); v6 != results_v6.end(); v6++)
	    cout << diplo::KM.Get(*v6) << " ";
	  cout << endl;
 	  cout << "Results for v7: ";
	  for (auto v7 = results_v7.begin(); v7 != results_v7.end(); v7++)
	    cout << diplo::KM.Get(*v7) << " ";
	  cout << endl;
	  cout << "Results for v8: ";
	  for (auto v8 = results_v8.begin(); v8 != results_v8.end(); v8++)
	    cout << diplo::KM.Get(*v8) << " ";
	  cout << endl;
	  cout << "Results for v9: ";
	  for (auto v9 = results_v9.begin(); v9 != results_v9.end(); v9++)
	    cout << diplo::KM.Get(*v9) << " ";
	  cout << endl;

	  cout << "Provenance: (";
	  for (auto p0 = prov_v0.begin(); p0 != prov_v0.end(); p0++)
	    cout << diplo::KM.Get(*p0) << " + ";
	  cout << ") x (";
	  for (auto p3 = prov_v3.begin(); p3 != prov_v3.end(); p3++)
	    cout << diplo::KM.Get(*p3) << " + ";
	  cout << ") x (";
	  for (auto p4 = prov_v4.begin(); p4 != prov_v4.end(); p4++)
	    cout << diplo::KM.Get(*p4) << " + ";
	  cout << ") x (";
	  for (auto p5 = prov_v5.begin(); p5 != prov_v5.end(); p5++)
	    cout << diplo::KM.Get(*p5) << " + ";
	  cout << ") x (";
	  for (auto p6 = prov_v6.begin(); p6 != prov_v6.end(); p6++)
	    cout << diplo::KM.Get(*p6) << " + ";
	  cout << ") x (";
	  for (auto p7 = prov_v7.begin(); p7 != prov_v7.end(); p7++)
	    cout << diplo::KM.Get(*p7) << " + ";
	  cout << ") x (";
	  for (auto p8 = prov_v8.begin(); p8 != prov_v8.end(); p8++)
	    cout << diplo::KM.Get(*p8) << " + ";
	  cout << ") x (";
	  for (auto p9 = prov_v9.begin(); p9 != prov_v9.end(); p9++)
	    cout << diplo::KM.Get(*p9) << " + ";
	  cout << ")" << endl;
	}
      }
    }
  }

  void printResults(vector<vector<KEY_ID>> &results) {
    for (auto mapping: results) {
      cout << "( ";
      for (auto value: mapping)
	cout << diplo::KM.Get(value) << " ";
      cout << ")" << endl;
    }
  }
  
  /*
    PREFIX foaf: <http://xmlns.com/foaf/>
    PREFIX mo: <http://purl.org/ontology/mo/>
    PREFIX sorg: <http://schema.org/>
    PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
    SELECT ?v0 ?v2 ?v3 WHERE {
      ?v0 foaf:age wsdbm:AgeGroup4 .
      ?v0 foaf:familyName ?v2 .
      ?v3 mo:artist ?v0 .
      ?v0 sorg:nationality wsdbm:Country1 .
    }
  */
  void WatDivprov::s4() {
    // Final results
    vector<vector<KEY_ID>> results;
    
    // Used URIs
    KEY_ID foaf_age = diplo::KM.Get("<http://xmlns.com/foaf/age>");
    KEY_ID foaf_familyName = diplo::KM.Get("<http://xmlns.com/foaf/familyName>");
    KEY_ID wsdbm_AgeGroup4 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/AgeGroup4>");
    KEY_ID wsdbm_Country1 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Country1>");
    KEY_ID sorg_nationality = diplo::KM.Get("<http://schema.org/nationality>");
    KEY_ID mo_artist = diplo::KM.Get("<http://purl.org/ontology/mo/artist>");

    // Get value for ?v0 from triple (?v0 foaf:age wsdbm:AgeGroup4)
    unordered_set<KEY_ID> results_v0_t1;
    vector<unordered_set<KEY_ID>> prov_v0_t1;
    API::GetSubjects(wsdbm_AgeGroup4, foaf_age, results_v0_t1, prov_v0_t1);
    
    // Get value for ?v0 from triple (?v0 sorg:nationality wsdbm:Country1)
    unordered_set<KEY_ID> results_v0_t4;
    vector<unordered_set<KEY_ID>> prov_v0_t4;
    API::GetSubjects(wsdbm_Country1, sorg_nationality, results_v0_t4, prov_v0_t4);
    
    // Intersect both sets of results for ?v0
    unordered_set<KEY_ID> results_v0;
    for (auto v0: results_v0_t1)
      if (results_v0_t4.count(v0) > 0)
	results_v0.insert(v0);

    for (auto v0: results_v0_t1) {
      // Get value for ?v2 from triple (?v0 foaf:familyName ?v2)
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;
      API::GetObjects(v0, foaf_familyName, results_v2, prov_v2);

      // Get value for ?v3 from triple (?v3 mo:artist ?v0)
      unordered_set<KEY_ID> results_v3;
      vector<unordered_set<KEY_ID>> prov_v3;
      API::GetSubjects(v0, mo_artist, results_v3, prov_v3);

      for (auto v2: results_v2)
	for (auto v3: results_v3)
	  results.push_back({v0, v2, v3});
    }

    printResults(results);
  }

  /*
   * PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
   * PREFIX sorg: <http://schema.org/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v1 ?v2 WHERE {
   *   ?v0 rdf:type ?v1 .
   *   ?v0 sorg:text ?v2 .
   *   wsdbm:User818157 wsdbm:likes ?v0 .
   * }
   */
  void WatDivprov::s7() {
    vector<vector<KEY_ID>> results;
    
    KEY_ID wsdbm_User818157 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/User818157>");
    KEY_ID rdf_type = diplo::KM.Get("<http://www.w3.org/1999/02/22-rdf-syntax-ns/type>");
    KEY_ID sorg_text = diplo::KM.Get("<http://schema.org/text>");
    KEY_ID wsdbm_likes = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/likes>");
	
    // Get value for ?v0 from triple (wsdbm:User818157 wsdbm:likes ?v0)
    unordered_set<KEY_ID> results_v0;
    unordered_set<KEY_ID> prov_v0;
    API::GetObjects(wsdbm_User818157, wsdbm_likes, results_v0, prov_v0);

    for (auto v0: results_v0) {
      // Get value for ?v1 from triple (?v0 rdf:type ?v1)
      unordered_set<KEY_ID> results_v1;
      unordered_set<KEY_ID> prov_v1;
      API::GetObjects(v0, rdf_type, results_v1, prov_v1);
    
      // Get value for ?v2 from triple (?v0 sorg:text ?v2)
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;
      API::GetObjects(v0, sorg_text, results_v2, prov_v2);
      
      for (auto v1: results_v1)
	for (auto v2: results_v2)
	  results.push_back({v0, v1, v2});
    }
    
    printResults(results);
  }

  /*
   * PREFIX og: <http://ogp.me/ns#>
   * PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
   * PREFIX sorg: <http://schema.org/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v2 ?v3 ?v4 ?v5 WHERE {
   *   ?v0 og:tag wsdbm:Topic245 .
   *   ?v0 rdf:type ?v2 .
   *   ?v3 sorg:trailer ?v4 .
   *   ?v3 sorg:keywords ?v5 .
   *   ?v3 wsdbm:hasGenre ?v0 .
   *   ?v3 rdf:type wsdbm:ProductCategory2 .
   * }
   */
  void WatDivprov::f1() {
    vector<vector<KEY_ID>> results;

    KEY_ID wsdbm_Topic245 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Topic245>");
    KEY_ID wsdbm_hasGenre = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/hasGenre>");
    KEY_ID wsdbm_ProductCategory2 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/ProductCategory2>");
    KEY_ID og_tag = diplo::KM.Get("<http://ogp.me/ns#tag>");
    KEY_ID rdf_type = diplo::KM.Get("<http://www.w3.org/1999/02/22-rdf-syntax-ns/type>");
    KEY_ID sorg_trailer = diplo::KM.Get("<http://schema.org/trailer>");
    KEY_ID sorg_keywords = diplo::KM.Get("<http://schema.org/keywords>");
    
    // Get ?v0 from (?v0 og:tag wsdbm:Topic245)
    unordered_set<KEY_ID> results_v0;
    vector<unordered_set<KEY_ID>> prov_v0;
    API::GetSubjects(wsdbm_Topic245, og_tag, results_v0, prov_v0);

    for (auto v0: results_v0) {
      // Get ?v2 from (?v0 rdf:type ?v2)
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;
      API::GetObjects(v0, rdf_type, results_v2, prov_v2);
      
      // Get ?v3 from (?v3 wsdbm:hasGenre ?v0)
      unordered_set<KEY_ID> results_v3_1;
      vector<unordered_set<KEY_ID>> prov_v3_1;
      API::GetSubjects(v0, wsdbm_hasGenre, results_v3_1, prov_v3_1);
    
      // Get ?v3 from (?v3 rdf:type wsdbm:ProductCategory2)
      unordered_set<KEY_ID> results_v3_2;
      vector<unordered_set<KEY_ID>> prov_v3_2;
      API::GetSubjects(wsdbm_ProductCategory2, rdf_type, results_v3_2, prov_v3_2);

      // Intersect results for v3
      unordered_set<KEY_ID> results_v3;
      for (auto v3: results_v3_1)
	if (results_v3_2.count(v3) > 0)
	  results_v3.insert(v3);

      for (auto v3: results_v3) {
	// Get ?v4 from (?v3 sorg:trailer ?v4)
	unordered_set<KEY_ID> results_v4;
	unordered_set<KEY_ID> prov_v4;
	API::GetObjects(v3, sorg_trailer, results_v4, prov_v4);
      
	// Get ?v5 from (?v3 sorg:keywords ?v5)
	unordered_set<KEY_ID> results_v5;
	unordered_set<KEY_ID> prov_v5;
	API::GetObjects(v3, sorg_keywords, results_v5, prov_v5);

	for (auto v2: results_v2)
	  for (auto v3: results_v3)
	    for (auto v4: results_v4)
	      for (auto v5: results_v5)
		results.push_back({v0, v2, v3, v4, v5});
      }
    }
    
    printResults(results);
  }

  /*
   * PREFIX foaf: <http://xmlns.com/foaf/>
   * PREFIX og: <http://ogp.me/ns#>
   * PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
   * PREFIX sorg: <http://schema.org/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v1 ?v2 ?v4 ?v5 ?v6 ?v7 WHERE {
   *   ?v0 foaf:homepage ?v1 .
   *   ?v0 og:title ?v2 .
   *   ?v0 rdf:type ?v3 .
   *   ?v0 sorg:caption ?v4 .
   *   ?v0 sorg:description ?v5 .
   *   ?v1 sorg:url ?v6 .
   *   ?v1 wsdbm:hits ?v7 .
   *   ?v0 wsdbm:hasGenre wsdbm:SubGenre79 .
   * }
  */
  void WatDivprov::f2() {
    vector<vector<KEY_ID>> results;

    KEY_ID wsdbm_SubGenre79 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/SubGenre79>");
    KEY_ID wsdbm_hasGenre = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/hasGenre>");
    KEY_ID wsdbm_hits = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/hits>");
    KEY_ID foaf_homepage = diplo::KM.Get("<http://xmlns.com/foaf/homepage>");
    KEY_ID og_title = diplo::KM.Get("<http://ogp.me/ns#title>");
    KEY_ID rdf_type = diplo::KM.Get("<http://www.w3.org/1999/02/22-rdf-syntax-ns/type>");
    KEY_ID sorg_caption = diplo::KM.Get("<http://schema.org/caption>");
    KEY_ID sorg_description = diplo::KM.Get("<http://schema.org/description>");
    KEY_ID sorg_url = diplo::KM.Get("<http://schema.org/url>");
	
    // ?v0 wsdbm:hasGenre wsdbm:SubGenre79 .
    unordered_set<KEY_ID> results_v0;
    vector<unordered_set<KEY_ID>> prov_v0;
    API::GetSubjects(wsdbm_SubGenre79, wsdbm_hasGenre, results_v0, prov_v0);

    for (auto v0: results_v0) {
      // ?v0 og:title ?v2 .
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;
      API::GetObjects(v0, og_title, results_v2, prov_v2);
    
      // ?v0 rdf:type ?v3 .
      unordered_set<KEY_ID> results_v3;
      unordered_set<KEY_ID> prov_v3;
      API::GetObjects(v0, rdf_type, results_v3, prov_v3);
      
      // ?v0 sorg:caption ?v4 .
      unordered_set<KEY_ID> results_v4;
      unordered_set<KEY_ID> prov_v4;
      API::GetObjects(v0, sorg_caption, results_v4, prov_v4);
      
      // ?v0 sorg:description ?v5 .
      unordered_set<KEY_ID> results_v5;
      unordered_set<KEY_ID> prov_v5;
      API::GetObjects(v0, sorg_description, results_v5, prov_v5);

      // ?v0 foaf:homepage ?v1 .
      unordered_set<KEY_ID> results_v1;
      unordered_set<KEY_ID> prov_v1;
      API::GetObjects(v0, foaf_homepage, results_v1, prov_v1);
      
      for (auto v1: results_v1) {
	// ?v1 sorg:url ?v6 .
	unordered_set<KEY_ID> results_v6;
	unordered_set<KEY_ID> prov_v6;
	API::GetObjects(v1, sorg_url, results_v6, prov_v6);
      
	// ?v1 wsdbm:hits ?v7 .
	unordered_set<KEY_ID> results_v7;
	unordered_set<KEY_ID> prov_v7;
	API::GetObjects(v1, wsdbm_hits, results_v7, prov_v7);
	
	for (auto v2: results_v2)
	  for (auto v3: results_v3)
	    for (auto v4: results_v4)
	      for (auto v5: results_v5)
		for (auto v6: results_v6)
		  for (auto v7: results_v7)
		    results.push_back({v0, v1, v2, v3, v4, v5, v6, v7});
      }
    }
    
    printResults(results);
  }

  /*
   * PREFIX sorg: <http://schema.org/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v1 ?v2 ?v4 ?v5 ?v6 WHERE {
   *   ?v0 sorg:contentRating ?v1 .
   *   ?v0 sorg:contentSize ?v2 .
   *   ?v0 wsdbm:hasGenre wsdbm:SubGenre73 .
   *   ?v4 wsdbm:makesPurchase ?v5 .
   *   ?v5 wsdbm:purchaseDate ?v6 .
   *   ?v5 wsdbm:purchaseFor ?v0 .
   * }
   */
  void WatDivprov::f3() {
    vector<vector<KEY_ID>> results;

    KEY_ID wsdbm_SubGenre73 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/SubGenre73>");
    KEY_ID wsdbm_hasGenre = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/hasGenre>");
    KEY_ID wsdbm_purchaseFor = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/purchaseFor>");
    KEY_ID wsdbm_makesPurchase = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/makesPurchase>");
    KEY_ID wsdbm_purchaseDate = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/purchaseDate>");
    KEY_ID sorg_contentRating = diplo::KM.Get("<http://schema.org/contentRating>");
    KEY_ID sorg_contentSize = diplo::KM.Get("<http://schema.org/contentSize>");
    
    // ?v0 wsdbm:hasGenre wsdbm:SubGenre73 .
    unordered_set<KEY_ID> results_v0;
    vector<unordered_set<KEY_ID>> prov_v0;
    API::GetSubjects(wsdbm_SubGenre73, wsdbm_hasGenre, results_v0, prov_v0);
    
    for (auto v0: results_v0) {
      // ?v0 sorg:contentRating ?v1 .
      unordered_set<KEY_ID> results_v1;
      unordered_set<KEY_ID> prov_v1;
      API::GetObjects(v0, sorg_contentRating, results_v1, prov_v1);
    
      // ?v0 sorg:contentSize ?v2 .
      unordered_set<KEY_ID> results_v2;
      unordered_set<KEY_ID> prov_v2;
      API::GetObjects(v0, sorg_contentSize, results_v2, prov_v2);

      // ?v5 wsdbm:purchaseFor ?v0 .
      unordered_set<KEY_ID> results_v5;
      vector<unordered_set<KEY_ID>> prov_v5;
      API::GetSubjects(v0, wsdbm_purchaseFor, results_v5, prov_v5);

      for (auto v5: results_v5) {
	// ?v4 wsdbm:makesPurchase ?v5 .
	unordered_set<KEY_ID> results_v4;
	vector<unordered_set<KEY_ID>> prov_v4;
	API::GetSubjects(v5, wsdbm_makesPurchase, results_v4, prov_v4);
      
	// ?v5 wsdbm:purchaseDate ?v6 .
	unordered_set<KEY_ID> results_v6;
	unordered_set<KEY_ID> prov_v6;
	API::GetObjects(v5, wsdbm_purchaseDate, results_v6, prov_v6);

	for (auto v1: results_v1)
	  for (auto v2: results_v2)
	    for (auto v4: results_v4)
	      for (auto v6: results_v6)
		results.push_back({v0, v1, v2, v4, v5, v6});
      }
    }
    
    printResults(results);
  }

  /*
   * PREFIX foaf: <http://xmlns.com/foaf/>
   * PREFIX gr: <http://purl.org/goodrelations/>
   * PREFIX og: <http://ogp.me/ns#>
   * PREFIX sorg: <http://schema.org/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v1 ?v2 ?v4 ?v5 ?v6 ?v7 ?v8 WHERE {
   *   ?v0 foaf:homepage ?v1 .
   *   ?v2 gr:includes ?v0 .
   *   ?v0 og:tag wsdbm:Topic232 .
   *   ?v0 sorg:description ?v4 .
   *   ?v0 sorg:contentSize ?v8 .
   *   ?v1 sorg:url ?v5 .
   *   ?v1 wsdbm:hits ?v6 .
   *   ?v1 sorg:language wsdbm:Language0 .
   *   ?v7 wsdbm:likes ?v0 .
   * }
   */
  void WatDivprov::f4() {
    vector<vector<KEY_ID>> results;

    KEY_ID wsdbm_Topic232 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Topic232>");
    KEY_ID wsdbm_Language0 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Language0>");
    KEY_ID wsdbm_likes = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/likes>");
    KEY_ID wsdbm_hits = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/hits>");
    KEY_ID sorg_language = diplo::KM.Get("<http://schema.org/language>");
    KEY_ID sorg_contentSize = diplo::KM.Get("<http://schema.org/contentSize>");
    KEY_ID og_tag = diplo::KM.Get("<http://ogp.me/ns#tag>");
    KEY_ID foaf_homepage = diplo::KM.Get("<http://xmlns.com/foaf/homepage>");
    KEY_ID sorg_url = diplo::KM.Get("<http://schema.org/url>");
    KEY_ID sorg_description = diplo::KM.Get("<http://schema.org/description>");
    KEY_ID gr_includes = diplo::KM.Get("<http://purl.org/goodrelations/includes>");
    
    // ?v0 og:tag wsdbm:Topic232 .
    unordered_set<KEY_ID> results_v0;
    vector<unordered_set<KEY_ID>> prov_v0;
    API::GetSubjects(wsdbm_Topic232, og_tag, results_v0, prov_v0);

    // ?v1 sorg:language wsdbm:Language0 .
    unordered_set<KEY_ID> results_v1_1;
    vector<unordered_set<KEY_ID>> prov_v1_1;
    API::GetSubjects(wsdbm_Language0, sorg_language, results_v1_1, prov_v1_1);
    
    for (auto v0: results_v0) {
      // ?v0 foaf:homepage ?v1 .
      unordered_set<KEY_ID> results_v1_2;
      unordered_set<KEY_ID> prov_v1_2;
      API::GetObjects(v0, foaf_homepage, results_v1_2, prov_v1_2);

      unordered_set<KEY_ID> results_v1;
      for (auto v1: results_v1_2)
	if (!results_v1_1.count(v1))
	  results_v1.insert(v1);
      
      // ?v2 gr:includes ?v0 .
      unordered_set<KEY_ID> results_v2;
      vector<unordered_set<KEY_ID>> prov_v2;
      API::GetSubjects(v0, gr_includes, results_v2, prov_v2);
      
      // ?v0 sorg:description ?v4 .
      unordered_set<KEY_ID> results_v4;
      unordered_set<KEY_ID> prov_v4;
      API::GetObjects(v0, sorg_description, results_v4, prov_v4);

      // ?v7 wsdbm:likes ?v0 .
      unordered_set<KEY_ID> results_v7;
      vector<unordered_set<KEY_ID>> prov_v7;
      API::GetSubjects(v0, wsdbm_likes, results_v7, prov_v7);
      
      // ?v0 sorg:contentSize ?v8 .
      unordered_set<KEY_ID> results_v8;
      unordered_set<KEY_ID> prov_v8;
      API::GetObjects(v0, sorg_contentSize, results_v8, prov_v8);
      
      for (auto v1: results_v1) {
	// ?v1 sorg:url ?v5 .
	unordered_set<KEY_ID> results_v5;
	unordered_set<KEY_ID> prov_v5;
	API::GetObjects(v1, sorg_url, results_v5, prov_v5);
      
	// ?v1 wsdbm:hits ?v6 .
	unordered_set<KEY_ID> results_v6;
	unordered_set<KEY_ID> prov_v6;
	API::GetObjects(v1, wsdbm_hits, results_v6, prov_v6);
	
	for (auto v2: results_v2)
	  for (auto v4: results_v4)
	    for (auto v5: results_v5)
	      for (auto v6: results_v6)
		for (auto v7: results_v7)
		  for (auto v8: results_v8)
		    results.push_back({v0, v1, v2, v4, v5, v6, v7, v8});
      }
    }
	 
    printResults(results);
  }

  /**
   * PREFIX gr: <http://purl.org/goodrelations/>
   * PREFIX og: <http://ogp.me/ns#>
   * PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * SELECT ?v0 ?v1 ?v3 ?v4 ?v5 ?v6 WHERE {
   *   ?v0 gr:includes ?v1 .
   *   wsdbm:Retailer222 gr:offers ?v0 .
   *   ?v0 gr:price ?v3 .
   *   ?v0 gr:validThrough ?v4 .
   *   ?v1 og:title ?v5 .
   *   ?v1 rdf:type ?v6 .
   * }
   */
  void WatDivprov::f5() {
    vector<vector<KEY_ID>> results;

    KEY_ID gr_includes = diplo::KM.Get("<http://purl.org/goodrelations/includes>");
    KEY_ID gr_price = diplo::KM.Get("<http://purl.org/goodrelations/price>");
    KEY_ID wsdbm_Retailer222 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Retailer222>");
    KEY_ID gr_offers = diplo::KM.Get("<http://purl.org/goodrelations/offers>");
    KEY_ID gr_validThrough = diplo::KM.Get("<http://purl.org/goodrelations/validThrough>");
    KEY_ID og_title = diplo::KM.Get("<http://ogp.me/ns#title>");
    KEY_ID rdf_type = diplo::KM.Get("<http://www.w3.org/1999/02/22-rdf-syntax-ns/type>");

    // wsdbm:Retailer222 gr:offers ?v0 .
    unordered_set<KEY_ID> results_v0;
    unordered_set<KEY_ID> prov_v0;
    API::GetObjects(wsdbm_Retailer222, gr_offers, results_v0, prov_v0);

    for (auto v0: results_v0) {
      // ?v0 gr:price ?v3 .
      unordered_set<KEY_ID> results_v3;
      unordered_set<KEY_ID> prov_v3;
      API::GetObjects(v0, gr_price, results_v3, prov_v3);
    
      // ?v0 gr:validThrough ?v4 .
      unordered_set<KEY_ID> results_v4;
      unordered_set<KEY_ID> prov_v4;
      API::GetObjects(v0, gr_validThrough, results_v4, prov_v4);
      
      // ?v0 gr:includes ?v1 .
      unordered_set<KEY_ID> results_v1;
      unordered_set<KEY_ID> prov_v1;
      API::GetObjects(v0, gr_includes, results_v1, prov_v1);

      for (auto v1: results_v1) {
	// ?v1 og:title ?v5 .
	unordered_set<KEY_ID> results_v5;
	unordered_set<KEY_ID> prov_v5;
	API::GetObjects(v1, og_title, results_v5, prov_v5);

	// ?v1 rdf:type ?v6 .
	unordered_set<KEY_ID> results_v6;
	unordered_set<KEY_ID> prov_v6;
	API::GetObjects(v1, rdf_type, results_v6, prov_v6);

	for (auto v3: results_v3)
	  for (auto v4: results_v4)
	    for (auto v5: results_v5)
	      for (auto v6: results_v5)
		results.push_back({v0, v1, v3, v4, v5, v6});
      }
    }
	       
    printResults(results);
  }
  
  /*
    PREFIX sorg: <http://schema.org/>
    PREFIX rev: <http://purl.org/stuff/rev#>
    SELECT ?v0 ?v4 ?v6 ?v7 WHERE {
      ?v0 sorg:caption ?v1 .         # 25157
      ?v0 sorg:text ?v2 .            # 74978
      ?v0 sorg:contentRating ?v3 .   # 13
      ?v0 rev:hasReview ?v4 .        # 1480510
      ?v4 rev:title ?v5 .            # 449175
      ?v4 rev:reviewer ?v6 .         # 308121
      ?v7 sorg:actor ?v6 .           # 115364
      ?v7 sorg:language ?v8 .        # 35
    }
  */
  void WatDivprov::c1() {
    vector<vector<KEY_ID>> results;

    // Create URIs
    KEY_ID sorg_caption = diplo::KM.Get("<http://schema.org/caption>");
    KEY_ID sorg_text = diplo::KM.Get("<http://schema.org/text>");
    KEY_ID sorg_contentRating = diplo::KM.Get("<http://schema.org/contentRating>");
    KEY_ID sorg_actor = diplo::KM.Get("<http://schema.org/actor>");
    KEY_ID sorg_language = diplo::KM.Get("<http://schema.org/language>");
    KEY_ID rev_hasReview = diplo::KM.Get("<http://purl.org/stuff/rev#hasReview>");
    KEY_ID rev_title = diplo::KM.Get("<http://purl.org/stuff/rev#title>");
    KEY_ID rev_reviewer = diplo::KM.Get("<http://purl.org/stuff/rev#reviewer>");

    const vector<char *> contentRatingValues = {
      "\"8\"",
      "\"9\"",
      "\"6\"", 
      "\"7\"", 
      "\"11\"",
      "\"13\"",
      "\"16\"",
      "\"10\"",
      "\"14\"",
      "\"18\"",
      "\"12\"",
      "\"17\"",
      "\"15\""};

    for (auto contentRatingValue: contentRatingValues) {
      KEY_ID v3 = diplo::KM.Get(contentRatingValue);

      // (?v0 sorg:contentRating ?v3)
      unordered_set<KEY_ID> results_v0;
      vector<unordered_set<KEY_ID>> prov_v0;
      API::GetSubjects(v3, sorg_contentRating, results_v0, prov_v0);
      
      for (auto v0: results_v0) {
	// (?v0 sorg:caption ?v1)
	unordered_set<KEY_ID> results_v1;
	unordered_set<KEY_ID> prov_v1;
	API::GetObjects(v0, sorg_caption, results_v1, prov_v1);
    
	// (?v0 sorg:text ?v2)
	unordered_set<KEY_ID> results_v2;
	unordered_set<KEY_ID> prov_v2;
	API::GetObjects(v0, sorg_text, results_v2, prov_v2);
	
	// (?v0 rev:hasReview ?v4)
	unordered_set<KEY_ID> results_v4;
	unordered_set<KEY_ID> prov_v4;
	API::GetObjects(v0, rev_hasReview, results_v4, prov_v4);

	for (auto v4: results_v4) {
	  // (?v4 rev:title ?v5)
	  unordered_set<KEY_ID> results_v5;
	  unordered_set<KEY_ID> prov_v5;
	  API::GetObjects(v4, rev_title, results_v5, prov_v5);
	
	  // (?v4 rev:reviewer ?v6)
	  unordered_set<KEY_ID> results_v6;
	  unordered_set<KEY_ID> prov_v6;
	  API::GetObjects(v4, rev_reviewer, results_v6, prov_v6);

	  for (auto v6: results_v6) {
	    // (?v7 sorg:actor ?v6)
	    unordered_set<KEY_ID> results_v7;
	    vector<unordered_set<KEY_ID>> prov_v7;
	    API::GetSubjects(v6, sorg_actor, results_v7, prov_v7);

	    for (auto v7: results_v7) {
	      // (?v7 sorg:language ?v8)
	      unordered_set<KEY_ID> results_v8;
	      unordered_set<KEY_ID> prov_v8;
	      API::GetObjects(v7, sorg_language, results_v8, prov_v8);
	      
	      for (auto v1: results_v1)
		for (auto v2: results_v2)
		  for (auto v5: results_v5)
		    for (auto v8: results_v8)
		      results.push_back({v0, v1, v2, v3, v4, v5, v6, v7, v8});
	    }
	  }
	}
      }
    }

    printResults(results);
  }

  /**
   * PREFIX sorg: <http://schema.org/>
   * PREFIX rev: <http://purl.org/stuff/rev#>
   * PREFIX gr: <http://purl.org/goodrelations/>
   * PREFIX wsdbm: <http://db.uwaterloo.ca/~galuc/wsdbm/>
   * PREFIX foaf: <http://xmlns.com/foaf/>
   * SELECT ?v0 ?v3 ?v4 ?v8 WHERE {
   *   ?v0 sorg:legalName ?v1 .
   *   ?v0 gr:offers ?v2 .
   *   ?v2 sorg:eligibleRegion wsdbm:Country5 .
   *   ?v2 gr:includes ?v3 .
   *   ?v4 sorg:jobTitle ?v5 .
   *   ?v4 foaf:homepage ?v6 .
   *   ?v4 wsdbm:makesPurchase ?v7 .
   *   ?v7 wsdbm:purchaseFor ?v3 .
   *   ?v3 rev:hasReview ?v8 .
   *   ?v8 rev:totalVotes ?v9 .
   * }
   */
  void WatDivprov::c2() {
    vector<vector<KEY_ID>> results;

    KEY_ID gr_offers = diplo::KM.Get("<http://purl.org/goodrelations/offers>");
    KEY_ID gr_includes = diplo::KM.Get("<http://purl.org/goodrelations/includes>");
    KEY_ID sorg_eligibleRegion = diplo::KM.Get("<http://schema.org/eligibleRegion>");
    KEY_ID sorg_legalName = diplo::KM.Get("<http://schema.org/legalName>");
    KEY_ID wsdbm_purchaseFor = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/purchaseFor>");
    KEY_ID wsdbm_makesPurchase = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/makesPurchase>");
    KEY_ID wsdbm_Country5 = diplo::KM.Get("<http://db.uwaterloo.ca/galuc/wsdbm/Country5>");
    KEY_ID rev_hasReview = diplo::KM.Get("<http://purl.org/stuff/rev#hasReview>");
    KEY_ID rev_totalVotes = diplo::KM.Get("<http://purl.org/stuff/rev#totalVotes>");
    KEY_ID foaf_homepage = diplo::KM.Get("<http://xmlns.com/foaf/homepage>");
    KEY_ID sorg_jobTitle = diplo::KM.Get("<http://schema.org/jobTitle>");

    // ?v2 sorg:eligibleRegion wsdbm:Country5 .
    unordered_set<KEY_ID> results_v2;
    vector<unordered_set<KEY_ID>> prov_v2;
    API::GetSubjects(wsdbm_Country5, sorg_eligibleRegion, results_v2, prov_v2);

    for (auto v2: results_v2) {

      // ?v0 gr:offers ?v2 .
      unordered_set<KEY_ID> results_v0;
      vector<unordered_set<KEY_ID>> prov_v0;
      API::GetSubjects(v2, gr_offers, results_v0, prov_v0);

      for (auto v0: results_v0) {
	// ?v0 sorg:legalName ?v1 .
	unordered_set<KEY_ID> results_v1;
	unordered_set<KEY_ID> prov_v1;
	API::GetObjects(v0, sorg_legalName, results_v1, prov_v1);
    
	// ?v2 gr:includes ?v3 .
	unordered_set<KEY_ID> results_v3;
	unordered_set<KEY_ID> prov_v3;
	API::GetObjects(v2, gr_includes, results_v3, prov_v3);

	for (auto v3: results_v3) {
	  // ?v7 wsdbm:purchaseFor ?v3 .
	  unordered_set<KEY_ID> results_v7;
	  vector<unordered_set<KEY_ID>> prov_v7;
	  API::GetSubjects(v3, wsdbm_purchaseFor, results_v7, prov_v7);

	  // ?v3 rev:hasReview ?v8 .
	  unordered_set<KEY_ID> results_v8;
	  unordered_set<KEY_ID> prov_v8;
	  API::GetObjects(v3, rev_hasReview, results_v8, prov_v8);

	  for (auto v8: results_v8) {
	    // ?v8 rev:totalVotes ?v9 .
	    unordered_set<KEY_ID> results_v9;
	    unordered_set<KEY_ID> prov_v9;
	    API::GetObjects(v8, rev_totalVotes, results_v9, prov_v9);

	    for (auto v7: results_v7) {
	      // ?v4 wsdbm:makesPurchase ?v7 .
	      unordered_set<KEY_ID> results_v4;
	      vector<unordered_set<KEY_ID>> prov_v4;
	      API::GetSubjects(v7, wsdbm_makesPurchase, results_v4, prov_v4);

	      for (auto v4: results_v4) {
		// ?v4 sorg:jobTitle ?v5 .
		unordered_set<KEY_ID> results_v5;
		unordered_set<KEY_ID> prov_v5;
		API::GetObjects(v4, sorg_jobTitle, results_v5, prov_v5);
		
		// ?v4 foaf:homepage ?v6 .
		unordered_set<KEY_ID> results_v6;
		unordered_set<KEY_ID> prov_v6;
		API::GetObjects(v4, foaf_homepage, results_v6, prov_v6);
		
		for (auto v1: results_v1)
		  for (auto v5: results_v5)
		    for (auto v6: results_v6)
		      for (auto v9: results_v9)
			results.push_back({v0, v1, v2, v3, v4, v5, v6, v7, v8, v9});
	      }
	    }
	  }
	}
      }
    }
    
    printResults(results);
  }

  void WatDivprov::runthemall() {
#ifdef SHOW_STATS
    queriesStart << "#r\t#m\t#mf\t#prov\t#im\t#imf\t#i\t#ec\t#er" <<endl;
#endif
    cout << "---------------------c1---------------------" << endl;
    diplo::moleculesCounter = 0;
    diplo::ProvFilterCounter = 0;
    diplo::ProvFilterCH = false;
    diplo::elementsChecked = 0;
    diplo::elementsRetrieved = 0;
    c1();

    // cout << "---------------------c2---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // c2();

    // cout << "---------------------l1---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // l1();

    // cout << "---------------------l2---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // l2();

    // cout << "---------------------l4---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // l4();

    // cout << "---------------------l5---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // l5();

    // cout << "---------------------s1---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // s1();

    // cout << "---------------------s4---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // s4();

    // cout << "---------------------s7---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // s7();

    // cout << "---------------------f1---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // f1();

    // cout << "---------------------f2---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // f2();

    // cout << "---------------------f3---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // f3();

    // cout << "---------------------f4---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // f4();

    // cout << "---------------------f5---------------------" << endl;
    // diplo::moleculesCounter = 0;
    // diplo::ProvFilterCounter = 0;
    // diplo::ProvFilterCH = false;
    // diplo::elementsChecked = 0;
    // diplo::elementsRetrieved = 0;
    // f5();
  }

  void WatDivprov::benchmark() {
    vector<vector<double> > times4exel;
    times4exel.resize(10);
    double time;
    cout << fixed;
    for (int i = 0; i < 5; i++) {
      // cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      // diplo::stopwatch_start();
      // c1();
      // time = diplo::stopwatch_get();
      // times4exel[0].push_back(time);
      // cout << "Runtime round " << i << " template c1: " << time << endl;
      // sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      c2();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template c2: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      l1();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template l1: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      l2();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template l2: " << time << endl;
      sleep(diplo::pause_int);
      
      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      l4();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template l4: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      l5();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template l5: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      s1();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template s1: " << time << endl;
      sleep(diplo::pause_int);
      
      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      s4();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template s4: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      s7();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template s7: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      f1();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template f1: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      f2();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template f2: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      f3();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template f3: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      f4();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template f4: " << time << endl;
      sleep(diplo::pause_int);

      cout << "--------------------- ROUND: " << i << "---------------------" << endl;
      diplo::stopwatch_start();
      f5();
      time = diplo::stopwatch_get();
      times4exel[0].push_back(time);
      cout << "Runtime round " << i << " template f5: " << time << endl;
      sleep(diplo::pause_int);
    }

    // printing for exel
    {
      for (vector<vector<double> >::iterator q = times4exel.begin();
	   q != times4exel.end(); q++) {
	for (size_t r = 0; r < q->size(); r++) {
	  string n = to_string((*q)[r]);
	  benchmarkResults << n << "\t";
	}
	if (!q->empty())
	  benchmarkResults << endl;
      }
    }
  }
  
}
