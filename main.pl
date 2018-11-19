/*
███████╗██╗  ██╗██╗██████╗ ██╗██████╗ ██╗   ██╗██████╗  ██████╗
██╔════╝██║ ██╔╝██║██╔══██╗██║██╔══██╗██║   ██║██╔══██╗██╔════╝
███████╗█████╔╝ ██║██║  ██║██║██████╔╝██║   ██║██████╔╝██║  ███╗
╚════██║██╔═██╗ ██║██║  ██║██║██╔═══╝ ██║   ██║██╔══██╗██║   ██║
███████║██║  ██╗██║██████╔╝██║██║     ╚██████╔╝██████╔╝╚██████╔╝
╚══════╝╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝╚═╝      ╚═════╝ ╚═════╝  ╚═════╝
*/
/*Start Game*/
start :-
  print_title,
  helpcmd,
  repeat,
    read(In),
    exec(In), nl,
  (In == exit; endgame).

/*Command execution alias*/
exec(map) :- map, !.
exec(look) :- look, !.
exec(tick) :- deadzone_tick, !.
exec(n) :- move(0,-1), !.
exec(e) :- move(1,0), !.
exec(s) :- move(0,1), !.
exec(w) :- move(-1,0), !.
exec(help) :- helpcmd, !.
exec(exit) :- write('Yah kok udahan :('),!.
exec(_) :- write('Invalid command, kan programnya belum kelar :('), !.

/*Miscelanious*/
print_title :-
  write('=============== WELCOME TO LAST TEAM STANDING\'S ==============='),nl,
  write('███████╗██╗  ██╗██╗██████╗ ██╗██████╗ ██╗   ██╗██████╗  ██████╗'),nl,
  write('██╔════╝██║ ██╔╝██║██╔══██╗██║██╔══██╗██║   ██║██╔══██╗██╔════╝'),nl,
  write('███████╗█████╔╝ ██║██║  ██║██║██████╔╝██║   ██║██████╔╝██║  ███╗'),nl,
  write('╚════██║██╔═██╗ ██║██║  ██║██║██╔═══╝ ██║   ██║██╔══██╗██║   ██║'),nl,
  write('███████║██║  ██╗██║██████╔╝██║██║     ╚██████╔╝██████╔╝╚██████╔╝'),nl,
  write('╚══════╝╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝╚═╝      ╚═════╝ ╚═════╝  ╚═════╝'),nl,nl.

helpcmd :-
  write('Currently usable command:'),nl,
  write('  $- map  : print the whole map'),nl,
  write('  $- look : look around'),nl,
  write('  $- tick : shrink the deadzone'),nl,
  write('  $- n    : move north'),nl,
  write('  $- e    : move east'),nl,
  write('  $- s    : move south'),nl,
  write('  $- w    : move west'),nl,
  write('  $- help : show this help'),nl,
  write('  $- exit : exit the game'),nl.

/*Endgame Conditions*/
endgame :-
  player_pos(X,Y),
  deadzone_size(V),
  (X@=<V; Y@=<V; Vright is 11-V ,X@>=Vright; Vright is 11-V ,Y@>=Vright), !,
  write('Skidipapman kehabisan darah dan mati di deadzone'),nl.


/*Deklarasi rule player*/
:- dynamic player_pos/2.
player_pos(5,5).

:- dynamic player_health/1.
player_health(100).

:- dynamic player_armor/1.
player_armor(0).

:- dynamic player_ammo/1.
player_ammo(0).

:- dynamic player_inv/1.
player_inv(15).

:- dynamic in_inv/1.

/*Deklarasi objek/item*/
weapon_obj(awm).
weapon_obj(m24).
weapon_obj(akm).
weapon_obj(p18c).
weapon_type(awm,sniper).
weapon_type(m24,smg).
weapon_type(akm,smg).
weapon_type(p18c,pistol).
weapon_dmg(awm,70).
weapon_dmg(m24,30).
weapon_dmg(akm,20).
weapon_dmg(p18c,10).
:- dynamic weapon_pos/3.
/*Position for testing purposes*/
weapon_pos(1,1,awm).

ammo_obj(sniper_ammo).
ammo_obj(smg_ammo).
ammo_obj(pistol_ammo).
ammo_type(sniper_ammo,sniper).
ammo_type(smg_ammo,smg).
ammo_type(pistol_ammo,pistol).
ammo_count(sniper_ammo,5).
ammo_count(smg_ammo,20).
ammo_count(pistol_ammo,10).
:- dynamic ammo_pos/3.
/*Position for testing purposes*/
ammo_pos(1,3,sniper_ammo).

armor_obj(helm_spetsnaz).
armor_obj(helm_military).
armor_obj(vest_military).
armor_obj(vest_police).
armor_amount(helm_spetsnaz,30).
armor_amount(helm_military,15).
armor_amount(vest_military,50).
armor_amount(vest_police,30).
:- dynamic armor_pos/3.
/*Position for testing purposes*/
armor_pos(3,4,helm_spetsnaz).

med_obj(med_kit).
med_obj(first_aid_kit).
med_heal(med_kit,40).
med_heal(first_aid_kit,80).
:- dynamic med_pos/3.
/*Position for testing purposes*/
med_pos(3,3,med_kit).

/*Deklarasi dan rule terkait map*/
:- dynamic deadzone_size/1.
deadzone_size(0).

/*Konvensi : Peta dimulai di kiri atas pada koordinat (0,0).
             Nilai X membesar ke kanan.
             Nilai Y membesar ke bawah*/
/*Deadzone*/
print_pos(X,Y) :-
  deadzone_size(V),
  (X@=<V; Y@=<V; Vright is 11-V ,X@>=Vright; Vright is 11-V ,Y@>=Vright), !,
  write('X').
/*TODO : Enemy placement*/
/*Medicine*/
print_pos(X,Y) :-
  med_pos(A,B,_),
  A==X, B==Y, !,
  write('M').
/*Weapon*/
print_pos(X,Y) :-
  weapon_pos(A,B,_),
  A==X, B==Y, !,
  write('W').
/*Armor*/
print_pos(X,Y) :-
  armor_pos(A,B,_),
  A==X, B==Y, !,
  write('A').
/*Ammo*/
print_pos(X,Y) :-
  ammo_pos(A,B,_),
  A==X, B==Y, !,
  write('+').
/*Player*/
print_pos(X,Y) :-
  player_pos(A,B),
  A==X, B==Y, !,
  write('P').
/*Regular tiles*/
print_pos(_,_) :- write('-').

print_map(11,11) :- print_pos(11,11),nl,!.
print_map(11,Y) :- Ynew is Y+1, print_pos(11,Y),nl,!,print_map(0,Ynew).
print_map(X,Y) :- Xnew is X+1, print_pos(X,Y),!,print_map(Xnew,Y).

deadzone_tick :- deadzone_size(X), Xnew is X+1, retract(deadzone_size(X)), assertz(deadzone_size(Xnew)).

map :-
  write('You are in pochinki'),nl,
  write('Tiles info:'),nl,
  write(' [X] Deadzone  | [P] Player'),nl,
  write(' [M] Medicine  | [A] Armor'),nl,
  write(' [W] Weapon    | [+] Ammo'),nl,
  print_map(0,0).

look :-
  write('You look your surrounding'),nl,
  write('Tiles info:'),nl,
  write(' [X] Deadzone  | [P] Player'),nl,
  write(' [M] Medicine  | [A] Armor'),nl,
  write(' [W] Weapon    | [+] Ammo'),nl,nl,
  player_pos(X,Y),
  Xmin is X-1, Xplus is X+1, Ymin is Y-1, Yplus is Y+1,
  write(' '),print_pos(Xmin,Ymin), print_pos(X,Ymin), print_pos(Xplus,Ymin), nl,
  write(' '),print_pos(Xmin,Y), print_pos(X,Y), print_pos(Xplus,Y), nl,
  write(' '),print_pos(Xmin,Yplus), print_pos(X,Yplus), print_pos(Xplus,Yplus).

/*Deklarasi dan rule terkait movement player*/
is_valid_move(X,_) :- deadzone_size(V), X@=<V, !, fail.
is_valid_move(_,Y) :- deadzone_size(V), Y@=<V, !, fail.
is_valid_move(X,_) :- deadzone_size(V), Vright is 11-V ,X@>=Vright, !, fail.
is_valid_move(_,Y) :- deadzone_size(V), Vright is 11-V ,Y@>=Vright, !, fail.
is_valid_move(_,_).

move(X,Y) :-
  player_pos(A,B), Xmov is X+A, Ymov is Y+B, is_valid_move(Xmov,Ymov), !,
  retract(player_pos(A,B)), assertz(player_pos(Xmov,Ymov)).
/*Rule untuk invalid move*/
move(_,_) :- write('You cannot go into the deadzone, dumbass'),nl.
