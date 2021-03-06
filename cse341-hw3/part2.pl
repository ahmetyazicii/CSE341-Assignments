:- dynamic(visited_cities/1).

%knowledge base

flight(canakkale,erzincan,6). % fact: Canakkale and Erzincan has a flight with cost 6.
flight(erzincan,canakkale,6). % fact: Erzincan and Canakkale has a flight with cost 6.

flight(erzincan,antalya,3). % fact: Erzincan and Antalya has a flight with cost 3.
flight(antalya,erzincan,3). % fact: Antalya and Erzincan has a flight with cost 3.

flight(diyarbakir,antalya,4). % fact: Diyarbakir and Antalya has a flight with cost 4.
flight(antalya,diyarbakir,4). % fact: Antalya and Diyarbakir has a flight with cost 4.

flight(diyarbakir,ankara,8). % fact: Diyarbakir and Ankara has a flight with cost 8.
flight(ankara,diyarbakir,8). % fact: Ankara and Diyarbakir has a flight with cost 8.

flight(izmir,ankara,6). % fact: Izmir and Ankara has a flight with cost 6.
flight(ankara,izmir,6). % fact: Ankara and Izmir has a flight with cost 6.

flight(izmir,antalya,2). % fact: Izmir and Antalya has a flight with cost 2.
flight(antalya,izmir,2). % fact: Antalya and Izmir has a flight with cost 2.

flight(istanbul,izmir,2). % fact: Istanbul and Izmir has a flight with cost 2.
flight(izmir,istanbul,2). % fact: Izmir and Istanbul has a flight with cost 2.

flight(istanbul,ankara,1). % fact: Istanbul and Ankara has a flight with cost 1.
flight(ankara,istanbul,1). % fact: Ankara and Istanbul has a flight with cost 1.

flight(istanbul,rize,4). % fact: Istanbul and Rize has a flight with cost 4.
flight(rize,istanbul,4). % fact: Rize and Istanbul has a flight with cost 4.

flight(ankara,rize,5). % fact: Ankara and Rize has a flight with cost 5.
flight(rize,ankara,5). % fact: Rize and Ankara has a flight with cost 5.

flight(ankara,van,4). % fact: Ankara and Van has a flight with cost 4.
flight(van,ankara,4). % fact: Van and Ankara has a flight with cost 4.

flight(van,gaziantep,3). % fact: Van and Gaziantep has a flight with cost 3.
flight(gaziantep,van,3). % fact: Gaziantep and Van has a flight with cost 3.


visited_cities(0).

%rules

route(X,Y,C) :- flight(X,Y,C).
route(X,Y,C) :- flight(X,V,A),\+ visited_cities(V),assertz(visited_cities(V)),route(V,Y,B),C is A+B. 


