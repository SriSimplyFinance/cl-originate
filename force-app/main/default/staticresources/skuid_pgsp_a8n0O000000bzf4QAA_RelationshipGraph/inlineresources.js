(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		var graph = {
            nodes: {},
            links: {},
        };
        //create somewhere to put the force directed graph
        var width = $('#relationship-graph').width(),
        	height = $('#relationship-graph').height(),
        	boxWidth = 170,
        	boxHeight = 70,
        	gap = {
        	    width: 80,
        	    height: 100,
        	    sublevel: 50
        	},
        	label = {
        		width: 110,
        		height: 22,
        	},
        	margin = {
        	    top: 30,
        	    right: 16,
        	    bottom: 30,
        	    left: 16
        	},
        	nodes_data = [],
        	links_data = [],
        	levelLines = [];
        	svg;    
        var colorScheme = {
        	"Individual": "#FFA21D",
        	"Business": "#1CBDD4",
        	"Contract": "#48CE94",
        	"Deposit" : "#7F7F7F",
        	"Relationship": "#FFFFFF"
        }
        
        function camelCaseText(text){
            if(text){
                text = text[0].toUpperCase() + text.slice(1).toLowerCase();
            }
            return text;
        }
        
        // add account vertex to graph
        function addAccountNode(acc, level){
            if(!graph.nodes[acc.Id]){
                graph.nodes[acc.Id] = {
        		    'sid': acc.Id,
        		    'name': acc.Name,
        		    'type': 'Business',
        		    'level': level,
        		    'processed' : false
        		};
        		if(acc.clcommon__Legal_Entity_Type__c){
        		    graph.nodes[acc.Id]['class'] = acc.clcommon__Legal_Entity_Type__r.Name;
        		    if(acc.clcommon__Legal_Entity_Type__r.Name == 'Individual' 
        		        || acc.clcommon__Legal_Entity_Type__r.Name == 'Sole Proprietorship'){
        		        graph.nodes[acc.Id]['type'] = 'Individual';
        		    }
        		}
            } else {
                if(level < graph.nodes[acc.Id].level){
                    graph.nodes[acc.Id].level = level;
                }
            }
            return graph.nodes[acc.Id];
        }
        
        function addContractNode(contract, level){
            if(!graph.nodes[contract.Id]){
                graph.nodes[contract.Id] = {
                    'sid': contract.Id,
        		    'class': camelCaseText(contract.staging__Contract_Type__c),
        		    'level': level,
        		    'type': 'Contract',
                }
                if(contract.genesis__CL_Product__r){
                    graph.nodes[contract.Id].name = contract.genesis__CL_Product__r.clcommon__Product_Name__c;
                }
            } else {
                if(level < graph.nodes[contract.Id].level){
                    graph.nodes[contract.Id].level = level;
                }
            }
        }
        
        function addBankAccountNode(bankAccount, level){
            if(!graph.nodes[bankAccount.Id]){
                graph.nodes[bankAccount.Id] = {
                    'sid': bankAccount.Id,
        		    'name': bankAccount.staging__Bank_Name__c,
        		    'class': camelCaseText(bankAccount.staging__Account_Type__c),
        		    'level': level,
        		    'type': 'Deposit',
                }
            } else {
                if(level < graph.nodes[bankAccount.Id].level){
                    graph.nodes[bankAccount.Id].level = level;
                }
            }
        }
        
        // add relationships
        function addRelation(n1, n2, n1Ton2Relation, n2Ton1Relation){
            // check if the relation exists
            var areNodesLinked = false;
            if((graph.links[n1] && graph.links[n1][n2] && graph.links[n1][n2][0] == n1Ton2Relation) ||
                    (graph.links[n2] && graph.links[n2][n1] && graph.links[n2][n1][0] == n2Ton1Relation)){
                areNodesLinked = true;
            }
            if(!areNodesLinked){
                var n1Relations = graph.links[n1];
                if(!n1Relations){
                    n1Relations = {};
                    graph.links[n1] = n1Relations;
                }
                if(!n2Ton1Relation){
                    n2Ton1Relation = n1Ton2Relation;
                }
                n1Relations[n2] = [n1Ton2Relation, n2Ton1Relation];
            }
        }
        
        function getAccountSpecificData(account, level){
            var node = addAccountNode(account, level);
            if(!node.processed){
                node.processed = true;
                var accountQuery = "SELECT Id, " + 
                                        "(SELECT Id, clcommon__Related_Entity__c, " +
                                                "clcommon__Related_Entity__r.Id, " +
                                                "clcommon__Related_Entity__r.Name, " +
                                                "clcommon__Related_Entity__r.clcommon__Legal_Entity_Type__c, " +
                                                "clcommon__Related_Entity__r.clcommon__Legal_Entity_Type__r.Name, " +
                                                "clcommon__Related_Entity_Role__c, " +
                                                "clcommon__Entity_Role__c " +
                                            "FROM clcommon__EntityRelationships__r), " + 
                                        "(SELECT Id, clcommon__Entity__c, " +
                                                "clcommon__Entity__r.Id, " +
                                                "clcommon__Entity__r.Name, " +
                                                "clcommon__Entity__r.clcommon__Legal_Entity_Type__c, " +
                                                "clcommon__Entity__r.clcommon__Legal_Entity_Type__r.Name, " +
                                                "clcommon__Related_Entity_Role__c, " +
                                                "clcommon__Entity_Role__c " +
                                            "FROM clcommon__RelatedEntityRelationships__r), " + 
                                        "(SELECT Id, staging__Type__c, " + 
                                                "staging__Interface_Bank_Account__c, " +
                                                "staging__Interface_Bank_Account__r.Id, " +
                                                "staging__Interface_Bank_Account__r.staging__Account_Type__c, " +
                                                "staging__Interface_Bank_Account__r.staging__Bank_Name__c, " +
                                                "staging__Interface_Contract__c, " + 
                                                "staging__Interface_Contract__r.Id, " +
                                                "staging__Interface_Contract__r.staging__Contract_Type__c, " +
                                                "staging__Interface_Contract__r.genesis__CL_Product__c, " + 
                                                "staging__Interface_Contract__r.genesis__CL_Product__r.clcommon__Product_Name__c " + 
                                            "FROM staging__Interface_Party__r) " +
                                    "FROM Account WHERE ID = '" + account.Id + "'";
                
                var accResult = sforce.connection.query(accountQuery);  
                if(accResult && accResult.records){
                    var queriedAccount = accResult.getArray("records")[0];
                    
                    var accountsToProcess = [];
                    // add entities
                    var entityRelations = queriedAccount.clcommon__EntityRelationships__r;
                    if(entityRelations){
                        var records = [];
                        if(entityRelations.size > 1){
                            records = entityRelations.records;
                        } else {
                            records.push(entityRelations.records);
                        }  
                        for(var i = 0; i < records.length; i++) {
                            var relation = records[i];
                            addRelation(queriedAccount.Id, 
                	                    relation.clcommon__Related_Entity__c, 
                	                    relation.clcommon__Entity_Role__c, 
                	                    relation.clcommon__Related_Entity_Role__c);
                	        addAccountNode(relation.clcommon__Related_Entity__r, level + 1);  
                	        accountsToProcess.push(relation.clcommon__Related_Entity__r);
                        }
                    }
                    
                    // add related entities
                    var relatedEntityRelations = queriedAccount.clcommon__RelatedEntityRelationships__r;
                    if(relatedEntityRelations){
                        var records = [];
                        if(relatedEntityRelations.size > 1){
                            records = relatedEntityRelations.records;
                        } else {
                            records.push(relatedEntityRelations.records);
                        }
                        for (var i = 0; i < records.length; i++) {
                            var relation = records[i];
                            addRelation(queriedAccount.Id, 
                	                    relation.clcommon__Entity__c, 
                	                    relation.clcommon__Related_Entity_Role__c, 
                	                    relation.clcommon__Entity_Role__c);
                	        addAccountNode(relation.clcommon__Entity__r, level + 1);
                	        accountsToProcess.push(relation.clcommon__Entity__r);
                        }
                    }
                    
                    // process parties
                    var parties = queriedAccount.staging__Interface_Party__r;
                    if(parties){
                        var records = [];
                        if(parties.size > 1){
                            records = parties.records;
                        } else {
                            records.push(parties.records);
                        }
                        for (var i = 0; i < records.length; i++) {
                            var party = records[i];
                            if(party.staging__Interface_Contract__c){
                                addContractNode(party.staging__Interface_Contract__r, level + 1);
                                addRelation(queriedAccount.Id, party.staging__Interface_Contract__c, camelCaseText(party.staging__Type__c));
                            } else if(party.staging__Interface_Bank_Account__c){
                                addBankAccountNode(party.staging__Interface_Bank_Account__r, level + 1);
                                addRelation(queriedAccount.Id, party.staging__Interface_Bank_Account__c, camelCaseText(party.staging__Type__c));
                            }
                        }
                    }
                    
                    // process added accounts
                    for (var i = 0; i < accountsToProcess.length; i++) {
                        getAccountSpecificData(accountsToProcess[i],  node.level + 1);
                    }
                    
                }
            }
        }
        
        function formatData(){
            // add all nodes and links to graph
            for(var key in graph.nodes){
            	var obj = graph.nodes[key];
            	obj.selected = false;
            	nodes_data.push(obj);
            	// get all links and map it
            	var relationMapping = graph.links[key];
            	if(relationMapping){
            		var parent = graph.nodes[key];
            		for(var linkKey in relationMapping){
            			var child = graph.nodes[linkKey];
            			links_data.push({
            				"source": parent.sid,
            				"target": child.sid,
            				"relationship": relationMapping[linkKey],
            			});
            		}
            	}
            }    
        }
        
        // add legend box
        function addLegend(parent){	
        	var container = parent.append("div").attr("class", "legend-box");
        	for (var key in colorScheme) {
        		if(colorScheme.hasOwnProperty(key)){
        			var divWrapper = container.append("div");
        			divWrapper.append("div")	
        					.attr("class", "legend")
        					.attr("style", function(){ return "background-color:" + colorScheme[key]});
        			divWrapper.append("div")	
        					.attr("class", "legend-text")
        					.text(function(){ return key; });
        		}
        	}	
        }
        
        // add filter
        function createFilterDefinition(svg) {
        	var defs = svg.append('svg:defs');
        	var dropShadowFilter = defs.append('svg:filter')
        	      						.attr('id', 'dropShadow')
        	      						.attr('filterUnits', "userSpaceOnUse")
        	      						.attr('width', '250%')
        	      						.attr('height', '250%');
            dropShadowFilter.append('svg:feGaussianBlur')
        			     	.attr('in', 'SourceGraphic') 
        			     	.attr('stdDeviation', 2)
        			     	.attr('result', 'blur-out'); 
            dropShadowFilter.append('svg:feColorMatrix')
        				    .attr('in', 'blur-out') 
        					.attr('type', 'hueRotate')
        					.attr('values', 180)	
        				    .attr('result', 'color-out'); 
            dropShadowFilter.append('svg:feOffset')
        		  			.attr('in', 'color-out')
        				    .attr('dx', 2)
        				    .attr('dy', 2)
        				    .attr('result', 'the-shadow');
            dropShadowFilter.append('svg:feBlend')
        	      			.attr('in', 'SourceGraphic')
        	      			.attr('in2', 'the-shadow')
        		  			.attr('mode', 'normal');
        
        }
        
        // find node by sid
        function findNodeBySID(text) {
        	"use strict";
        	var i;
        	for (i = 0; i < nodes_data.length; i += 1) {
        	    if (nodes_data[i].sid === text) {
        	        return nodes_data[i];
        	    }
        	}
        	return null;
        }
        
        var account = skuid.model.getModel('RG_SelectedAccount').getFirstRow();
        getAccountSpecificData(account, 0);
        formatData();
        var parent = d3.select("#relationship-graph");
        var svg = parent.attr("width", width)
        				.attr("height", height)
        				.attr("overflow", "scroll")
        				.append("svg")
        					.attr("width", function(){
        						var minWidth = margin.left + margin.right + 2*(boxWidth + gap.width);
        						if(minWidth > width){
        							width = minWidth;
        						} 
        						return width;
        					})
        					.attr("height", height)
        					.append("g");
        addLegend(parent);
        createFilterDefinition(svg);
        
        
        var maxNodesPerRow = (width - (margin.left + margin.right) + gap.width)/(gap.width + boxWidth); // get max no of nodes
        	maxNodesPerRow = Math.floor(maxNodesPerRow);			
        var isMaxNodesPerRowEven = (maxNodesPerRow % 2 == 0) ? true : false;
        renderRelationshipGraph(maxNodesPerRow);
        
        // this function takes care of generating node positions by calculating levels, sublevels and column positions
        function renderRelationshipGraph(maxNodesPerRow) {
        	var count = [];
        	var subLevel = [];
        	var maxHeight = height - margin.bottom;
        
        	nodes_data.forEach(function (d, i) {
        		if(count[d.level]){
        			count[d.level] += 1;
        		} else {
        			count[d.level] = 1;
        		}
        		
        		d.colIndex = (count[d.level] - 1) % maxNodesPerRow;
        		d.sublevel = Math.floor((count[d.level] - 1)/maxNodesPerRow);
        		subLevel[d.level] = d.sublevel;
        	});
            
            count.forEach(function(node, index){
        		var lNode = {
        			level : index,	
        		}
        		var totalNoOfSubLevels = 0;
        		for(var t = 0; t <= index ; t++){
        			totalNoOfSubLevels = totalNoOfSubLevels + subLevel[t];
        		}
        		lNode.y = margin.top + ((boxHeight + gap.height) * index) + ((boxHeight + gap.sublevel) * totalNoOfSubLevels) + boxHeight + gap.height/2;
        		levelLines.push(lNode);
        	});
        
        	nodes_data.forEach(function (d, i) {
        		if(d.level == 0){
        			if(isMaxNodesPerRowEven){
        				d.x = margin.left + ((boxWidth + gap.width) * (maxNodesPerRow/2)) - (gap.width + boxWidth)/2;
        			} else {
        				d.x = margin.left + ((boxWidth + gap.width) * ((maxNodesPerRow - 1)/2));
        			}
        		} else {
        			d.x = margin.left + ((boxWidth + gap.width) * d.colIndex);
        		}
        		
        		// get no of levels
        		var totalNoOfSubLevels = 0;
        		for(var t = 0; t < d.level ; t++){
        			totalNoOfSubLevels = totalNoOfSubLevels + subLevel[t];
        		}
        		d.y = margin.top + ((boxHeight + gap.height) * d.level) + ((boxHeight + gap.sublevel) * (totalNoOfSubLevels + d.sublevel));
        		if(d.y > maxHeight){
        			maxHeight = d.y + boxHeight;
        		}
        		d.id = "n" + i;
        	});
        	
        	links_data.forEach(function (d) {
        		d.source = findNodeBySID(d.source);
        		d.target = findNodeBySID(d.target);
                d.id = "l" + d.source.id + d.target.id,
                d.sourcerole = d.relationship[0],
                d.targetrole = d.relationship[1] ? d.relationship[1] : d.relationship[0]; 		
        	});
        
        	if(maxHeight + margin.bottom > height){ 
        		d3.select("#relationship-graph > svg").attr("height", maxHeight + margin.bottom); // set svg height to see scroll bar
        	}
        }
        	
        //set up the simulation 
        var simulation = d3.forceSimulation().nodes(nodes_data);                  
        var link_force =  d3.forceLink(links_data).id(function(d) { return d.id; });        
        var charge_force = d3.forceManyBody().strength(-100);
            
        var group = svg.append("g").attr("class", "nodes");
        var node = svg.select(".nodes")
        			    .selectAll("g")
        			    .data(nodes_data)
        			    .enter()
        			    .append("g")
        			    .attr("class", "unit");
        
        var clickNode;
        node.append("rect")
        	.attr("x", function (d) { return d.x; })
        	.attr("y", function (d) { return d.y; })
        	.attr("id", function (d) { return d.id; })
        	.attr("width", boxWidth)
        	.attr("height", boxHeight)
        	.attr("class", "node")
        	.attr("fill", function(d){ return colorScheme[d.type]})
        	.attr("stroke", function(d){ return colorScheme[d.type]})
        	.attr("stroke-width", "1px")
        	.attr("cursor", "pointer")
        	.attr("selected", false)
        	.attr("rx", 10)
        	.attr("ry", 10)
        	.attr('filter', 'url(#dropShadow)')
        	.on("click", function () {
        		if(clickNode){
        			clickNode.selected = false;
        			addOrRemoveLinks(d3.select(clickNode).datum(), false);
        		}
        		clickNode = this;
        		clickNode.selected = true;
        		addOrRemoveLinks(d3.select(clickNode).datum(), true);
        	});
        
        // add a group to each node for rect which contains relation text
        node.append("g")
        	.attr("class", "text-box")
        	.attr("id", function (d) { return "text-" + d.id; })
        	.attr("active", false)
        	.append("rect")
        		.attr("class", "relation")
        		.attr("cursor", "pointer")
        		.attr("fill", function(){ return colorScheme["Relationship"];})
        		.attr("stroke", "#7F7F7F")
        		.attr("stroke-width", "1px")
        		.attr("rx", 5)
        		.attr("ry", 5)
        		.attr("x", function (d) { return d.x + boxWidth/2 - label.width/2; })
        		.attr("y", function (d) { return d.y - label.height/2 - 2; })
        		.attr("width", label.width)
        		.attr("height", label.height);
        
        // add relation name place holder
        node.selectAll("g.text-box")
        		.append("text")
        		.attr("font-family", "Lato")
        		.attr("font-size", "12")
        		.attr("font-weight", "400")
        		.attr("fill", "#37444e")
        		.attr("text-anchor", "middle")
        		.attr("pointer-events", "none")
        		.attr("x", function (d) { return d.x + boxWidth/2})
        		.attr("y", function (d) { return d.y + 2; }); // to move to center
        
        
        //add node name
        var nameTextNode = node.append("text")
        	.attr("x", function (d) { return d.x + boxWidth/2; })
        	.attr("y", function (d) { return d.y + 2*(boxHeight/5); })
        	.attr("font-family", "Lato")
        	.attr("font-size", "12")
        	.attr("font-weight", "700")
        	.attr("fill", "#ffffff")
        	.attr("text-anchor", "middle")
        	.attr("pointer-events", "none")
        	//.text(function (d) { return d.name; });
        	    
        nameTextNode.append("tspan").text(function (d) { 
            if(d.name && d.name.length > 30){
                return d.name.slice(0,29);
            } else{
                return d.name; 
            }
        });
        nameTextNode.append("tspan")
                .attr("x", function (d) { return d.x + boxWidth/2; })
        	        .attr("y", function (d) { return 12 + d.y + 2*(boxHeight/5); })
                    .text(function (d) { 
                        if(d.name && d.name.length > 30){
                            return d.name.slice(29);
                        } else{
                            return ''; 
                        }
                    });
        
        //add node class
        node.append("text")
        	//.attr("class", "sublabel")
        	.attr("x", function (d) { return d.x + boxWidth/2 ; })
        	.attr("y", function (d) { 
        	    var yoffset = 2;
        	    if(d.name && d.name.length > 30){
        	        yoffset = 12;
        	    }
        	    return d.y + 3*(boxHeight/5) + yoffset;
    	     })
        	.attr("font-family", "Lato")
        	.attr("font-size", "10")
        	.attr("font-weight", "700")
        	.attr("fill", "#ffffff")
        	.attr("text-anchor", "middle")
        	.attr("pointer-events", "none")
        	.text(function (d) { return d.class; });
        
        // add font awesome icon
        node.append("text")
        	.attr("id", function(d){ return "icon-" + d.id; })
        	.attr("x", function (d) { return d.x + boxWidth - 15; })
        	.attr("y", function (d) { return d.y + 15; })
        	.attr("font-family", "FontAwesome")
        	.attr("fill", "#37444E")
        	.attr("text-anchor", "right")
        	.attr("pointer-events", "none")
        	.attr("style", "visibility: hidden")
        	.text(function (d) { return '\uf058'; });
        
        var lineGenerator = d3.line();
        // draw level lines
        var levelGroup = svg.append("g").attr("class", "levels");
        var levels = levelGroup.selectAll("g")
            		.data(levelLines)
            		.enter()
            		.append("g")
            		    .attr("class", "level")
            		    .append("path")
            		    .attr("fill", "#7F7F7F")
            			.attr("stroke", "#7F7F7F")
            			.attr("stroke-width", "1px")
            			.attr("stroke-dasharray", "5, 5")
            			.attr("id", function(l){ return "level" + l.level})
            			.attr("d", function (l) { 
            				var dcurve = d3.curveLinear;
            				var pathCoordinates = [[margin.left, l.y], [ width - margin.right, l.y]];
            				return lineGenerator(pathCoordinates);
            			});
		
		var levelLabels =  levelGroup.selectAll("leveltext")
                    		.data(levelLines)
                    		.enter()
                    		.append('text')
					        .style("pointer-events", "none")
					        .attr("class", "leveltext")
        					.attr("fill", "#7F7F7F")
        					.attr("font-family", "Lato")
                        	.attr("font-size", "10")
                        	.attr("font-weight", "700");

        levelLabels.append('textPath')
        		.attr('xlink:href', function(l){ return "#level" + l.level})
        		.style("alignment-baseline", "ideographic")
        		.attr("startOffset", "5%")
        		.text(function (l) { return 'Level = ' + l.level; });
		
        
        function getPath(pathNodes){
        	var dcurve = d3.curveStepAfter;
        	lineGenerator.curve(dcurve);
        	var pathCoordinates = [];
        	if(pathNodes){
        		pathNodes.forEach(function(d){
        			pathCoordinates.push([d.y, d.x]);
        		});
        	}
        	return lineGenerator(pathCoordinates);
        }
        
        function getCoordinates(source, target){
        	var p1 = {}, p2 = {}, 
        		p3 = {}, p4 = {};
        	var connectionsList = [];
        	// check if the nodes are aligned horizontally
        	if(source.y == target.y){
        		p1.x = source.y;
        		p1.y = source.x + (boxWidth/2);
        
        		p2.x = source.y - boxHeight/2;
        		p2.y = source.x + (boxWidth/2);
        
        		p3.x = target.y - boxHeight/2;
        		p3.y = target.x + (boxWidth/2);
        
        		p4.x = target.y - label.height/2;
        		p4.y = target.x + (boxWidth/2);
        		connectionsList = [p1, p2, p3, p4];
        	} else if(source.x == target.x){
        		// if right most nodes are connected
        		if(source.colIndex == (maxNodesPerRow - 1)){ // to be tested
        			// join from left side
        			p1.x = source.y + boxHeight/2;
        			p1.y = source.x;
        
        			p2.x = source.y + boxHeight/2;
        			p2.y = source.x - gap.width/2;
        
        			p3.x = target.y + boxHeight/2;
        			p3.y = target.x - gap.width/2;
        
        			p4.x = target.y + boxHeight/2;
        			p4.y = target.x;		
        		} else {
        			// join from right side
        			p1.x = source.y + boxHeight/2;
        			p1.y = source.x + boxWidth;
        
        			p2.x = source.y + boxHeight/2;
        			p2.y = source.x + boxWidth + gap.width/2;
        
        			p3.x = target.y + boxHeight/2;
        			p3.y = target.x + boxWidth + gap.width/2;
        
        			p4.x = target.y + boxHeight/2;
        			p4.y = target.x + boxWidth;
        		}
        		connectionsList = [p1, p2, p3, p4];
        	} else {
        		// which side are the nodes located
        		var midpoint = ((margin.left + margin.right) + maxNodesPerRow*(gap.width + boxWidth) - gap.width)/2;	
        		var mid = maxNodesPerRow/2;
        		var isAdjustmentNeeded = isMaxNodesPerRowEven && 
        									((source.level == 0 && (target.colIndex == mid || target.colIndex == mid - 1)) ||   
        									(target.level == 0 && (source.colIndex == mid || source.colIndex == mid - 1)));
        		if((source.x < midpoint && target.x < midpoint) || (source.x > midpoint && target.x > midpoint)){
        			// both on left side or right side
        			if(source.x < target.x){
        				// left node = source
        				p1.x = source.y + boxHeight/2;
        				p1.y = source.x + boxWidth;
        
        				p2.x = source.y + boxHeight/2;
        				p2.y = source.x + boxWidth + gap.width/2;
        
        				p3.x = target.y + boxHeight/2;
        				p3.y = source.x + boxWidth + gap.width/2;
        
        				p4.x = target.y + boxHeight/2;
        				p4.y = target.x;	
        
        				if(isAdjustmentNeeded){
        					if(source.level == 0){
        						p1.x = p2.x = source.y + boxHeight;
        						p1.y = p2.y = source.x + boxWidth/2;
        					} else {
        						p3.x = p4.x = target.y + boxHeight;
        						p3.y = p4.y = target.x + boxWidth/2;
        					}
        				}
        				connectionsList = [p1, p2, p3, p4];
        			} else {
        				// left node = target
        				p1.x = target.y + boxHeight/2;
        				p1.y = target.x + boxWidth;
        
        				p2.x = target.y + boxHeight/2;
        				p2.y = target.x + boxWidth + gap.width/2;
        
        				p3.x = source.y + boxHeight/2;
        				p3.y = target.x + boxWidth + gap.width/2;
        
        				p4.x = source.y + boxHeight/2;
        				p4.y = source.x;
        
        				if(isAdjustmentNeeded){
        					if(source.level == 0){
        						p3.x = p4.x = source.y + boxHeight;
        						p3.y = p4.y = source.x + boxWidth/2;
        					} else {
        						p1.x = p2.x = target.y + boxHeight;
        						p1.y = p2.y = target.x + boxWidth/2;
        					}
        				}
        				connectionsList = [p1, p2, p3, p4];
        			}
        		} else {
        			// one on left and other on right
        			if(source.x < target.x){
        				p1.x = source.y + boxHeight/2;
        				p1.y = source.x + boxWidth;
        
        				p2.x = source.y + boxHeight/2;
        				p2.y = target.x - gap.width/2;
        
        				p3.x = target.y + boxHeight/2;
        				p3.y = target.x - gap.width/2;
        
        				p4.x = target.y + boxHeight/2;
        				p4.y = target.x;
        
        				if(isAdjustmentNeeded){
        					if(source.level == 0){
        						p1.x = p2.x = source.y + boxHeight;
        						p1.y = p2.y = source.x + boxWidth/2;
        						p3.y = source.x + boxWidth/2;
        					} else {
        						p3.x = p4.x = target.y + boxHeight;
        						p3.y = p4.y = target.x + boxWidth/2;
        						p2.y = target.x + boxWidth/2;
        					}
        				}
        				connectionsList = [p1, p2, p3, p4];
        			} else {
        				p1.x = target.y + boxHeight/2;
        				p1.y = target.x + boxWidth;
        
        				p2.x = target.y + boxHeight/2;
        				p2.y = source.x - gap.width/2;
        
        				p3.x = source.y + boxHeight/2;
        				p3.y = source.x - gap.width/2;
        
        				p4.x = source.y + boxHeight/2;
        				p4.y = source.x;
        
        				if(isAdjustmentNeeded){
        					if(source.level == 0){
        						p3.x = p4.x = source.y + boxHeight;
        						p3.y = p4.y = source.x + boxWidth/2;
        						p2.y = source.x + boxWidth/2;
        					} else {
        						p1.x = p2.x = target.y + boxHeight;
        						p1.y = p2.y = target.x + boxWidth/2;
        						p3.y = target.x + boxWidth/2;
        					}
        				}
        				connectionsList = [p1, p2, p3, p4];	
        			}		
        		} 	
        	}
        	return connectionsList;
        }
        
        var link = svg.append("g").attr("class", "links");
        
        function drawLine(lineId, source, target){
        	link.append("path")
        		.attr("class", "link")
        		.attr("active", true)
        		.attr("id", lineId)
        		.attr("marker-start", "url(#arrowhead)")
        		.attr("d", function () { 
        			var coordinates = getCoordinates(source, target);
        			return getPath(coordinates);
        		});
        }
        
        function addOrRemoveLinks(val, stat) {
        	d3.select("#" + val.id).attr("selected", stat);
        	if(stat){
        		d3.select("#icon-" + val.id).attr("style", "visibility: visible");
        	} else {
        		d3.select("#icon-" + val.id).attr("style", "visibility: hidden");
        	}
        	links_data.forEach(function (d) {
                if (d.source.id === val.id) {
                    d3.select("#" + d.target.id).attr("selected", stat);
                    d3.select("#text-" + d.target.id).attr("active", stat);
                    if(stat){
                    	drawLine(d.id, d.source, d.target);
                    	d3.select("#text-" + d.target.id + " > text").text(d.targetrole); // change relation text on path
                    } else {
                    	d3.select("#text-" + d.target.id + " > text").text(null); // change relation text on path
                    	d3.select("#" + d.id).remove();
                    }     
                } else if (d.target.id === val.id) {
                    d3.select("#" + d.source.id).attr("selected", stat);
                    d3.select("#text-" + d.source.id).attr("active", stat);  
                    if(stat){
                    	drawLine(d.id, d.target, d.source);
                    	d3.select("#text-" + d.source.id + " > text").text(d.sourcerole); // change relation text on path
                    } else {
                    	d3.select("#text-" + d.source.id + " > text").text(null); // change relation text on path
                    	d3.select("#" + d.id).remove();
                    }
                } 
        	});
        }
        d3.selectAll("#n0").each(function(d, i) {
            var onClickFunc = d3.select(this).on("click");
            onClickFunc.apply(this, [d, i]);
        });  
	});
})(skuid);;
}(window.skuid));