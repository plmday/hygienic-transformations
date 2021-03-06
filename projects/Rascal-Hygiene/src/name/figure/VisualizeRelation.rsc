module name::figure::VisualizeRelation

import name::NameGraph;
import vis::Figure;
import vis::KeySym;
import vis::Render;

import String;
import List;

Figure toFigure(NameGraph G, &T t) {
  return graph(
     [ellipse(text("<nameAt(v, t)> (<idString(v)>)"), left(), top(), isSyn(v) ? lineColor("red") : top(), 
          id("<v>"), 
          
          onMouseDown(bool (int btn, map[KeyModifier,bool] m) {
             edit(v);
          }))
          
           | v <- G.V ],
          
     [edge("<u>", "<d>", triangle(10,fillColor("black"))) | <u, d> <- G.E<0,1> ], 
     hint("layered"), width(900), /*height(1000),*/ gap(70));
}

str idString([l]) {
  return "line <l.begin.line>";
}
default str idString(id) = "syn";

bool isSyn([l]) = false;
default bool isSyn(id) = true;

void renderNames(NameGraph names, &T t) = 
  render(toFigure(names, t));
