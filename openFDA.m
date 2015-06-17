prompt={'Enter the start date',
        'Enter the end date',
        'Enter the manufacturer'};
name='OpenFDA MDR Search by Manufacturer';
numlines=1;
defaultanswer={'19910101','20050101','Medtronic'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
urlcount = char(strcat('https://api.fda.gov/device/event.json?api_key=XvyOkkPiQG5gfb2xy4Ai2KHfS56xcXlyk6Dh09vM&search=date_received:[',answer(1),'+TO+',answer(2),']+AND+device.manufacturer_d_name:',answer(3),'&count=manufacturer_d_name'));
res = parse_json(urlread(urlcount));
count = res{1}.results{1}.count
temp=struct
h = waitbar(0,'Please wait...');
url = char(strcat('https://api.fda.gov/device/event.json?api_key=XvyOkkPiQG5gfb2xy4Ai2KHfS56xcXlyk6Dh09vM&search=date_received:[',answer(1),'+TO+',answer(2),']+AND+device.manufacturer_d_name:',answer(3),'&limit=100&skip=',num2str(0)));
for step = 1:((count/5000)-1)
    disp(num2str(step))
    url = char(strcat('https://api.fda.gov/device/event.json?api_key=XvyOkkPiQG5gfb2xy4Ai2KHfS56xcXlyk6Dh09vM&search=date_received:[',answer(1),'+TO+',answer(2),']+AND+device.manufacturer_d_name:',answer(3),'&limit=100&skip=',num2str((step*100)+100)));
    result = loadjson(urlread(url));
    if step == 1 
        final = result.results;
        for i = 100:100:5000
            url = char(strcat('https://api.fda.gov/device/event.json?api_key=XvyOkkPiQG5gfb2xy4Ai2KHfS56xcXlyk6Dh09vM&search=date_received:[',answer(1),'+TO+',answer(2),']+AND+device.manufacturer_d_name:',answer(3),'&limit=100&skip=',num2str(i)));
            result = loadjson(urlread(url));
            final = [final, result.results]
            date = result.results{1,100}.date_received
        end
        
    else
        for i = 0:100:5000
            url = char(strcat('https://api.fda.gov/device/event.json?api_key=XvyOkkPiQG5gfb2xy4Ai2KHfS56xcXlyk6Dh09vM&search=date_received:[',date,'+TO+',answer(2),']+AND+device.manufacturer_d_name:',answer(3),'&limit=100&skip=',num2str(i)));
            result = loadjson(urlread(url));
            final = [final, result.results]
            date = result.results{1,100}.date_received
        end

    end   
    waitbar(step /(count/5000));
end
close(h) 
