#include <string.h>


#ifndef inf136564struct
#define inf136564struct

struct User {
    char login[20];
    char password[20];
    char group[20];
    int id;
    int isInGroup;
    int isConnectedToOtherUser;
    int isLoggedIn;
};
typedef struct User User;

struct Request {
	long type;
	char login[20];
	char password[20];
	char data[100][20];
};
typedef struct Request Request;

struct Response {
    long type;
    int value;
    int id;
    char data[100][20];
};
typedef struct Response Response;

struct DataMessage{
    long type;
    char senderLogin[20];
    char receiverLogin[20];
    char data[100];
};
typedef struct DataMessage DataMessage;

#endif
