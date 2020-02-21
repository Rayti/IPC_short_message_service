#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "inf136564_c.ch"



int main(int argc, char* argv[]){
    char login[20] = {""};
    char password[20] = {""};
    int * myId = malloc(sizeof(int));
    int logged = 0;
    int option;
    int quit = 0;
    while(!quit){
        printf("----------\nChoose option:\n");
        printf("1 - login\n2 - logout\n"
        "3 - users logged in\n4 - send message\n"
        "5 - show message\n6 - sign up to group\n"
        "7 - sign out of group\n8 - available groups list\n"
        "99 - quit\n----------\n");
        scanf("%d", &option);
        switch (option){
            case 1:{
                if(logged == 1){
                    printf("You are already logged in!\n");
                    break;
                }
                printf("Podaj login: ");
                scanf("%s", login);
                printf("Podaj haslo: ");
                scanf("%s", password);
                if(requestLogin(login, password, myId) >= 1){
                    logged = 1;
                }
                break;
            }
            case 2:{
                if(logged == 0 ){
                        printf("You are already logged out!\n");
                    break;
                }
                if(requestLogout(login, password) == 1){
                        logged = 0;
                }
                break;
            }
            case 3:{
                requestLoggedInUsers();
                break;
            }
            case 4:{
                if(logged == 0){
                    printf("First you have to log in!\n");
                    break;
                }
                char userToMessage[20];
                char dm[100];
                printf("Type in user you want to send message to: \n");
                scanf("%s", userToMessage);
                printf("type in message: \n");
                scanf("%s", dm);
                sendMessage(login, userToMessage, dm);
                break;
            }
            case 5:{
                if(logged == 0){
                    printf("First you have to log in!\n");
                    break;
                }
                receiveMessage(*myId);
                printf("Tu2\n");
                break;
            }
            case 6:{
                if(logged == 0){
                    printf("First you have to log in!\n");
                    break;
                }
                char groupName[20];
                printf("Type in group name you want to join: \n");
                scanf("%s", groupName);
                requestSigningUptoGroup(login, groupName);
                break;
            }
            case 7:{
                if(logged == 0){
                    printf("First you have to log in!\n");
                    break;
                }
                requestSigningOutOfGroup(login);
                break;
            }
            case 8:{
                if(logged == 0){
                    printf("First you have to log in!\n");
                    break;
                }
                requestGroupList();
                break;
            }
            case 99:{
                if(logged == 0) quit = 1;
                else{
                    requestLogout(login, password);
                    quit = 1;
                }
                break;
            }
            default:{
                printf("Wrong option!\n");
                break;
            }
            
        }
    }
}
