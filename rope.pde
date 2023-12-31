//              ,---------------------------,
//              |  /---------------------\  |
//              | |                       | |
//              | |     Jack Nemitz       | |
//              | |      CSCI 5611        | |
//              | |     Project 02        | |
//              | |     Rope class        | |
//              |  \_____________________/  |
//              |___________________________|
//            ,---\_____     []     _______/------,
//          /         /______________\           /|
//        /___________________________________ /  | ___
//        |                                   |   |    )
//        |  _ _ _                 [-------]  |   |   (
//        |  o o o                 [-------]  |  /    _)_
//        |__________________________________ |/     /  /
//    /-------------------------------------/|      ( )/
//  /-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
///-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
//
// The code contained within this file and all supporting files is generated by me,
// from example code given in class (marked as such), or from documentation as appropriate.
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

class Rope {
  public int node_number;
  public float restLen;
  public PVector anchor, end;
  public Node[] nodes;
  public int node_mass;
  PVector g = new PVector(0,9.8,0);

  Rope(int nodes, int node_mass, float rest, PVector anchor, PVector end) {
    this.node_number = nodes; // how many nodes to have per unit of rope
    this.node_mass = node_mass; // mass of each node in the rope
    this.restLen = rest; // length at which a rope unit is at rest/not stretched or compressed
    this.anchor = anchor; // the point at which the rope is anchored
    this.end = end; // the last node position in the rope
    this.nodes = new Node[node_number]; // array of nodes that make up the rope

    PVector vel = new PVector(0,0,0);
    // populate the node array by lerping from the anchor to the end node
    for (int i = 0; i < this.node_number; i++) {
      PVector pos = PVector.lerp(anchor, end, (float(i)/this.node_number));
      //PVector pos = new PVector(i * this.restLen, 0, -50);
      //println(pos, pos2);
      this.nodes[i] = new Node(pos, vel, this.node_mass);
    }
  }

  void update_physics(float t, int substeps, int relaxation_steps) {
    t = t/substeps;
    for(int s = 0; s < substeps; s++) {
      for (int i = 0; i < this.nodes.length; i++) {
        this.nodes[i].prev_pos = new PVector(this.nodes[i].pos.x, this.nodes[i].pos.y, this.nodes[i].pos.z);
        this.nodes[i].vel.add(PVector.mult(g, t));
        this.nodes[i].pos.add(PVector.mult(this.nodes[i].vel, t));
      }

      // relax

      for (int i = 0; i < relaxation_steps; i++) {
        for (int j = 1; j < this.nodes.length; j++) {
          PVector delta = PVector.sub(this.nodes[j].pos,this.nodes[j-1].pos);
          float delta_len = delta.mag();
          if (Float.isNaN(delta.x) || Float.isNaN(delta.y) || Float.isNaN(delta.z)) {
            delta_len = 0;
          }
          float correction = delta_len - this.restLen;
          PVector delta_normalized = delta.normalize();
          this.nodes[j].pos.sub(PVector.mult(delta_normalized, correction / 2));
          this.nodes[j-1].pos.add(PVector.mult(delta_normalized, correction / 2));
        }
        this.nodes[0].pos = new PVector(0,0,-50);
        this.anchor = this.nodes[0].pos;
      }
      for (int i = 0; i < this.nodes.length; i++) {
        this.nodes[i].vel = PVector.mult(PVector.sub(this.nodes[i].pos, this.nodes[i].prev_pos), 1/t);
      }

    }
  }
}

/*
void draw() {
  background(255,255,255);
  fill(255,0,0);
  stroke(0,0,0);

  Rope rope = new Rope(20, 1, 200, new PVector(300,100,0), new PVector(500,100,0));

  for (int i = 0; i < rope.nodes.length - 1; i++) {
    line(rope.nodes[i].pos.x, rope.nodes[i].pos.y, rope.nodes[i+1].pos.x, rope.nodes[i+1].pos.y);
    circle(rope.nodes[i].pos.x, rope.nodes[i].pos.y, 5);
  }
  circle(rope.nodes[19].pos.x, rope.nodes[19].pos.y, 5);
}
*/
