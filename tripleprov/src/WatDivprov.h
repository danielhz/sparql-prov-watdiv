/*
 * WatDivprov.h
 *
 *  Created on: Jun 03, 2021
 *      Author: Daniel Hernandez
 */

#ifndef WatDivPROV_H_
#define WatDivPROV_H_

#include "diplodocus.h"
#include "KeyManager.h"
#include "TypesHierarchy.h"
#include "TemplateManager.h"
#include "Molecules.h"
#include "API.h"
#include <algorithm>

using namespace diplo;

namespace queries {

  class WatDivprov {
    ofstream provOutput;
  public:
    WatDivprov();
    virtual ~WatDivprov();
    void mixer();
    void TPDemo();
    void c1();
    void l1();
    void l2();
    void l4();
    void l5();
    void s1();
    void s4();
    void s7();
    void f1();
    void runthemall();
    void benchmark();
  };

}


#endif /* WatDivPROV_H_ */
