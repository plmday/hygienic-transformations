module name::VisualizeRelation

import name::Relation;
import vis::Figure;
import vis::KeySym;
import vis::Render;
import util::Editors;

import String;
import List;

Figure toFigure(NameGraph G) {
  return graph(
     [ellipse(text("<nameOf(v, G)> (<idString(v)>)"), left(), top(), 
          id("<v>"), 
          
          onMouseDown(bool (int btn, map[KeyModifier,bool] m) {
             edit(v);
          }))
          
           | v <- G.V ],
          
     [edge("<u>", "<d>", triangle(10,fillColor("black"))) | <u, d> <- G.E<0,1> ], 
     hint("layered"), width(900), height(1000), gap(70));
}

str idString({l}) {
  return "line <l.begin.line>";
}
str idString(id) = "syn";

void renderNames(NameGraph names) = 
  render(toFigure(names));
