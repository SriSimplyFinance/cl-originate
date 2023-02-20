global class SAF_ExperianCreditSearchServiceMockTest implements HttpCalloutMock {
     global HTTPResponse respond(HTTPRequest request)
    {
        HttpResponse Finalresponse;
        if(String.valueOf(request.getEndpoint()).contains('api/kyc/login')){
            HttpResponse response =new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatusCode(200);
           response.setStatus('ok');
            String json='{'+
                ' "token_type": "Bearer ",'+
				'"expires_in": 7200000,'+
				'"access_token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbmRyZXcudHJpbW1lckBzaW1wbHkuZmluYW5jZSIsImlhdCI6MTYzODQ3ODUxNCwiZXhwIjoxNjM4NDg1NzE0fQ.R7lX1b9RCdGjq6uESGFp-Qy8dUlYGOEhRl8ahK-jsc4N_PUCElwpIfxVPyBPw3au11QL9KR4dsSTfzolZhs93Q"'+
                '}';   
            response.setBody(json);
            Finalresponse=response;	
        }
        else if(String.valueOf(request.getEndpoint()).contains('api/kyc/experian/v2/individual/run')) 
        {
            HttpResponse response =new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatusCode(200);
           response.setStatus('ok');
          String json='{'+
'"data": ['+
'{'+
'"id": "IND-0000015871",'+
'"name": "Mr Barry John Lampard",'+
'"ceased_on": null,'+
'"legal_entity_type": null,'+
'"legal_entity_type_id": null,'+
'"ownership": null,'+
'"parentCompany": 0,'+
'"bracket": null,'+
'"shareholder_perc": null,'+
'"nationality": "British",'+
'"country_of_residence": "England",'+
'"identification": null,'+
'"notified_on": "2020-01-09",'+
'"links": {'+
'"self": "/company/12393691/persons-with-significant-control/individual/Kp6o69cKmNCtMoXs7VpiteJaxb4",'+
'"officers": null,'+
'"charges": null,'+
'"filing_history": null'+
'},'+
'"kind": "individual-person-with-significant-control",'+
'"etag": "09fd674ed43e719b842869f2b6ee183235b1b8af",'+
'"address": {'+
'"address_line_1": "School House,The Street",'+
'"address_line_2": "Lympne",'+
'"locality": "Huthe",'+
'"country": "United Kingdom",'+
'"postal_code": "CT21 4LQ",'+
'"premises": "School House",'+
'"region": null,'+
'"registered_address_line1": "School House,The Street",'+
'"registered_city": "Huthe",'+
'"registered_county": null,'+
'"registered_country": "United Kingdom",'+
'"registered_postcode": "CT21 4LQ",'+
'"registered_address_premises": "School House",'+
'"registered_address_road": "The Street"'+
'},'+
'"name_elements": {'+
'"middle_name": "John",'+
'"title": "Mr",'+
'"surname": "Lampard",'+
'"forename": "Barry"'+
'},'+
'"natures_of_control": ['+
'"ownership-of-shares-75-to-100-percent"'+
'],'+
'"date_of_birth": {'+
'"month": "9",'+
'"year": "1973"'+
'},'+
'"cls_account_id": null'+
'}'+
'],'+
'"company_Number": "12393691"'+
'}';
         response.setBody(json);
         Finalresponse= response;   
            
        }  
        else if(String.valueOf(request.getEndpoint()).contains('/api/kyc/experian/v2/company/run')) 
        {
            HttpResponse response =new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatusCode(200);
           response.setStatus('ok');
          String json='{'+
'"etag": "e9e369914fdeb8dfb57d8bf98ae72e0f481c3a9d",'+
'"kind": "officer-list",'+
'"inactive_count": 0,'+
'"company_Number": "00456335",'+
'"total_results": 8,'+
'"links": {'+
'"self": "/company/00456335/officers",'+
'"officers": null,'+
'"charges": null,'+
'"filing_history": null'+
'},'+
'"errors": null,'+
'"resigned_count": 6,'+
'"active_count": 2,'+
'"start_index": 0,'+
'"items_per_page": 35,'+
'"items": ['+
'{'+
'"id": "IND-0000015832",'+
'"address": {'+
'"address_line_1": "Yew Trees",'+
'"address_line_2": null,'+
'"region": null,'+
'"country": null,'+
'"postal_code": "B94 6RU",'+
'"premises": null,'+
'"locality": "Solihull",'+
'"registered_address_line1": "Yew Trees",'+
'"registered_city": "Solihull",'+
'"registered_county": null,'+
'"registered_country": null,'+
'"registered_postcode": "B94 6RU",'+
'"registered_address_premises": null,'+
'"registered_address_road": "Yew Trees"'+
'},'+
'"date_of_birth": {'+
'"month": null,'+
'"year": null'+
'},'+
'"links": {'+
'"officer": {'+
'"appointments": "/officers/g5B_hHq0ZAwv0ld_Zh23H1Txm_A/appointments"'+
'},'+
'"self": "/company/00456335/appointments/xa-aFPXrOJ0OO8aKrQtBblNG0tg"'+
'},'+
'"appointed_on": "2005-04-03",'+
'"resigned_on": null,'+
'"middle_name": "Lee",'+
'"title": null,'+
'"surname": "LEWIS",'+
'"forename": "Esther",'+
'"name": "LEWIS, Esther Lee",'+
'"officer_role": "secretary",'+
'"occupation": null,'+
'"source_data_system": "Company House",'+
'"created_on": "2021-11-18",'+
'"country_of_residence": null,'+
'"nationality": null'+
'}'+
']}';
         response.setBody(json);
         Finalresponse= response;   
            
        } 
        else if(request.getEndpoint()=='dummy_Access_Endpoint')
        {
            HttpResponse response =new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatusCode(200);
           response.setStatus('ok');
          String json=' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
          '';
         response.setBody(json);
         Finalresponse=response;       
        } 
         else if(request.getEndpoint()=='dummy_Oppy_Endpoint')
        {
            HttpResponse response =new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatusCode(200);
           response.setStatus('ok');
          String json=' {"data":[{"code":"SUCCESS","details":{"Modified_Time":"2019-07-22T15:27:03+05:30","Modified_By":{"name":"Happiest Minds Dev","id":"10777000000162006"},"Created_Time":"2019-07-22T15:27:03+05:30","id":"10777000001221082","Created_By":{"name":"Happiest Minds Dev","id":"10777000000162006"}},"message":"record added","status":"success"}]}'+
          '';
         response.setBody(json);
         Finalresponse=response;       
        }
        else{
            HttpResponse response =new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatusCode(200);
        response.setStatus('ok');
        String json='{'+       
                                  '"users":[{'+
	                              '"country":"gb",'+
                                  '"role":{' +
	                                      '"name":"SalesManager",'+
                                          '"id":"10777000001201297"'+
	                                     '},'+      
                                  '"language":"en_TB",'+
                                  '"locale":"en_US",'+
                                  '" microsoft":"false",'+
                                //  '"Isonline":"false",'+
                                  '"Modified_By":{'+
                                                '"name":"System Admin",'+
                                                '"id":"10777000000140034"'+
                                                 '},' +
                                  '"id":"10777000001268001",'+
                                  '"country_locale":"US",'+
                                  '"first_name":"Paul",'+
                                  '"email":"paul.morrison@simply.finance",'+    
                                  '"created_time":"2019-08-01T15:35:00+05:30",'+
                                  '"Modified_Time":"2019-08-01T15:35:00+05:30",'+
                                  '"time_format":"hh:mm a",'+
                                  '"offset":"0",'+
                                  '"profile":{'+
                                           '"name":"Standard",'+
                                           '"id":"10777000001182794"'+
                                            '},'   +  
                                 '"last_name":"Morrison",'+
                                 '"time_zone":"GMT",'+
                                 '"created_by":{'+
		                                       '"name":"System Admin",'+
                                               '"id":"10777000000140034"'+
		                                      '},'+
                                '"zuid":"20067174770",'+
                            //      '"confirm":"true",'+
                                '"full_name":"PaulMorrison",'+
                                '"SFDC":"sfdc",'+
                                '"territories":[{'+
		                                       '}],'+    
                               '"date_format":"MM/dd/yyyy",'+
                               '"status":"active"'+
                                '}],'+
                              '"info":{'+
                                       '"per_page":"200",'+
                                       '"count":"117",'+
                                       '"page":"1"'+
                                    //   '"more_records":"true"'+
                                       '}'+
                        
            '}';
        response.setBody(json);
        Finalresponse=response;
        }
        
        return Finalresponse;
            
    }
    
 }