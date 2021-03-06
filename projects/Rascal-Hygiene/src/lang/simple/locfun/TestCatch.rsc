module lang::simple::locfun::TestCatch

import lang::simple::locfun::Catch;
import lang::simple::AST;
import lang::simple::Implode;
import IO;
import name::NameFix;
import name::HygienicCorrectness;


Prog prog1() = load(|project://Rascal-Hygiene/input/catchit.sim|);

void printProg1() {
  println(pretty(desugar(prog1())));
}

test bool testProgFixed1() {
  p1 = prog1();
  G = resolveNames(p1);
  p2 = desugar0(p1);
  
  p3 = nameFix(#Prog, G, p2, resolveNames); 
  
  println(pretty(p2));
  println(pretty(p3));
  return p2 != p3;
}

test bool testProgFixed2() {
  p1 = prog1();
  G = resolveNames(p1);
  p2 = desugar(p1);
  
  p3 = nameFix(#Prog, G, p2, resolveNames); 
  
  println(pretty(p2));
  println(pretty(p3));
  return p2 == p3;
}