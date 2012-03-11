// g++ -lGL dummygame.cpp -o dummygame

#include <GL/gl.h>
#include <iostream>

using namespace std;

struct Player {
  int max_hp;
  int hp;
};

int damage(Player &player) {
  player.hp--;  
}

int reset(Player &player) {
  player.max_hp = 10;
  player.hp = player.max_hp;
}

int dead_players = 0;

int main(int argc, char **argv)
{
    GLbitfield mask = GL_COLOR_BUFFER_BIT;
    Player p;
    int counter;

    cout << "Player address: " << &p << endl;
    cout << "Player max_hp address: " << &p.max_hp << endl;
    cout << "Player hp address: " << &p.hp << endl;

    reset(p);
    
    while (dead_players < 3) {
      counter++;
      if (counter % 50000000 == 0) {
        damage(p);
//        cout << "Player damaged. Actual HP: " << p.hp << endl;
        glClear(mask);
      }
      if (p.hp <= 0) {
        dead_players++;
        cout << "Dead players: " << dead_players << endl; 
        reset(p);
      }
    }
    return 0;
}
