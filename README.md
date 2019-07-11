# jsproxy-onekey
### Manual Mode
```
bash <(curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/experimental/install.sh)
```
### Automatic Mode
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/experimental/install.sh | bash -s auto <host> <port>
```
### Automatic Mode Examples 
***
#### Example(1)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/experimental/install.sh | bash -s auto example.com 443
```
Result:  
Waiting for installing...  
Installing finished...  
Now you can access https://example.com and enjoy.  
***
#### Example(2)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/experimental/install.sh | bash -s auto random 443
```
Result:  
Waiting for installing...  
Installing finished...  
Now you can access https://YourIP.Wildcard.DNS and enjoy.  
***
#### Example(3)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/experimental/install.sh | bash -s auto example.com 65536
```
Result:  
Waiting for installing...  
Error! Illigal Port!  
Now you can just modify parameters and run the script again.   
***
