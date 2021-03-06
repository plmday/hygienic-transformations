module name::figure::Figs

import vis::Figure;
import name::NameGraph;
import name::figure::VisualizeRelation;
import IO;
import vis::Render;

list[Figure] figs = [];

list[Figure] getFigs() = figs;

Figure getFig() = vcat(figs, gap(1), width(900));

bool renderFigs() {
  if (figs != [])
  	  render(getFig());
  return true;
}

bool resetFigs() {
  figs = [];
  return true;
}

void recordNameGraphFig(NameGraph g, &T t) {
  figs += [toFigure(g, t)];
}