# Code Examples - LachlanWilliams
Examples of original codes written by Lachlan Williams

# Inventory
<ol>
  <li>NACA4.m</li>
</ol>

# 1. NACA4.m
MATALAB code which plots any NACA4 airfoil profile.

Notes:
<ul>
  <li>Code presents relevant symmetric profile, chord line, and final cambered airfoil on a graph for visual verification.</li>
  <li>Plotted points exported to file in a space separated format ready to be imported into Solidworks using X,Y,Z Curve tool. Upper and lower surfaces written to separate files to prevent Solidworks auto-joining the TE (Trailing Edge) in spline and deforming profile.</li>
  <li>Boolean option to force the TE closed (NACA4 equations leave small gap at TE natively).</li>
</ul>

Potential improvements:
<ul>
  <li>Parse NACA4 string to variables option.</li>
  <li>Vectorize loops for improved efficiency in MATLAB.</li>
</ul>
  
