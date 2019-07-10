# jsproxy-onekey
Manual Mode
```
bash <(curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/master/install.sh)
```
Automatic Mode
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/master/install.sh | bash -s auto <host> <port>
```
Automatic Mode Examples  
Example(1)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/master/install.sh | bash -s auto example.com 443
```
Result:  
Waiting for installing...  
Installing finished...  
Now you can access https://example.com and enjoy.  
  
Example(2)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/master/install.sh | bash -s auto random 443
```
Result:  
Waiting for installing...  
Installing finished...  
Now you can access https://<Your IP>.Wildcard.DNS and enjoy.  
  
Example(3)  
Input:  
```
curl -L https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/master/install.sh | bash -s auto example.com 65536
```
Result:  
Waiting for installing...  
Error! Illigal Port!  
Now you can just modify parameters and run the script again.   
