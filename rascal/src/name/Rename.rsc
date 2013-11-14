module name::Rename

import name::Gensym;
import name::HygienicCorrectness;
import name::Relation;
import name::Names;
import IO;
import Map;
import String;


&T rename(NameGraph G, &T t, ID varId, str new) = rename(G.E, t, (varId:new));

&T rename(Edges refs, &T t, map[ID,str] subst) {
  return visit (t) {
    case str x => setID(subst[getID(x)], getID(x)) 
      when getID(x) in subst
    case str x => setID(subst[def], getID(x)) 
      // XXX: fails to call `refOf`
      // when def := refOf(x@location, refs) && def in subst
      when getID(x) in refs, def := refs[getID(x)], def in subst 
  };
}


//&T fixHygiene(NameGraph Gs, NameGraph Gt, &T t, &U(str) name2var) {
//  Edges badRefs = sourceNotPreserved(Gs, Gt) + synthesizedCaptured(Gs, Gt);
//  synth = synthesizedNodes(Gs, Gt);
//  set[loc] renameLocs 
//    = ({} | it + (l1 in synth ? {l1} : {}) + (l2 in synth ? {l2} : {}) 
//          | <l1,l2> <- badRefs<0,1> );
//  
//  usedNames = namesOf(Gt);
//  map[loc, &U] subst = ();
//  for (l <- renameLocs) {
//    str fresh = freshName(usedNames, Gt.N[l]);
//	usedNames += fresh;
//	freshVar = name2var(fresh);
//	subst += (l:freshVar);
//  };
//  
//  renamed = rename(Gt[1] - badRefs, t, subst);
//  return renamed;
//}

@doc {
  Cleaner paper version of fixHygiene that produces exactly the same result.
}
&T fixHygiene(<Vs,Es,Ns>, &T t, NameGraph(&T) resolveT) {
  Gt = <Vt,Et,Nt> = resolveT(t);
  
  //println("Source edges: <Es>");
  //println("Target edges: <Et>");
  
  notPreserveSourceBinding =    (u:Et[u] | u <- Vs & Vt, u in Es, u in Et && Es[u] != Et[u]);
  notPreserveDefinitionScope =  (u:Et[u] | d <- Vs & Vt, u <- Et, Et[u] == d, u in Es ? Es[u] != d : true);
  notSafeDefinitionReferences = (u:Et[u] | u <- Vs & Vt, u notin Es, u in Et, Et[u] != u);
  
  //println("not preserve source binding: <notPreserveSourceBinding>");
  //println("not preserve definition scope: <notPreserveDefinitionScope>");
  //println("not safe definition references: <notSafeDefinitionReferences>");

  allBadRefs = notPreserveSourceBinding + notPreserveDefinitionScope + notSafeDefinitionReferences;
  badDefinitionNodes = allBadRefs<1>;
  
  goodDefRefs = ( u:Es[u] | u <- notPreserveSourceBinding<0>, u in Es);
  // goodUseRefs required?
  goodUseRefs = ( u:d | d <- notPreserveDefinitionScope<1>, u <- Es, Es[u] == d);
  
  //iprintln(badDefRefs);
  //iprintln(badUseRefs);
  //iprintln(goodDefRefs);
  
  if (badDefinitionNodes == {})
    return t;
  
  usedNames = Nt<1>;
  subst = ();
  
  for (l <- badDefinitionNodes) {
    fresh = freshName(usedNames, nameOf(l, Gt));
    usedNames += fresh;
    subst += (l : fresh);
  };
  
  Et_new = Et - allBadRefs + goodDefRefs + goodUseRefs;
  
  &T t_new = rename(Et_new, t, subst);
  
  return fixHygiene(<Vs,Es,Ns>, t_new, resolveT);
}
