#!/bin/bash
# extracting bibtex from INSPIRE-HEP
# Baoyi Chen 2017

# search using arxiv number 
search_eprint() {
    arxiv_number=$1
	echo "searching the eprint number: $arxiv_number"
    search_eprint_result="https://inspirehep.net/search?ln=en&ln=en&p=find+eprint+$arxiv_number&of=hx&action_search=Search&sf=earliestdate&so=d&rm=&rg=25&sc=0"
}

# search using title
search_title() {
	title=$@
	search="${title[1]}"
	for term in $title; do
       search+="+$term"
    done
	echo "searching the title: $title"
	# exact title match (slow)
	search_title_result="https://inspirehep.net/search?ln=en&ln=en&p=find+t+%2F$search%2F&of=hx&action_search=Search&sf=earliestdate&so=d&rm=&rg=25&sc=0"
	# general title match (fast)
	#open "https://inspirehep.net/search?ln=en&ln=en&p=find+t+$search&of=hx&action_search=Search&sf=earliestdate&so=d&rm=&rg=25&sc=0"
}


# give all matched bibtex entries (should be used if the bibit method fails)
biball() {
    case "$1" in
    	# search using the eprint
        -e)
            eprint_number="${@:2}"
            search_eprint $eprint_number
            count=$(python bibcount.py $search_eprint_result)
            echo "$count record(s) found"

            if [ "$count" == 0 ]
            then 
                echo "Oops!"                
            fi
            # if less then 5 records found, display the results
            if [ "$count" -lt 5 ]
            then 
                echo "--------------------------------------"
                End=$(($count - 1))
                for i in $(seq 0 $End); do
                    result=$(python getbib.py $search_eprint_result $i 2>&1)
                    echo "$result"
                done
            fi
            # if more then 5 (including 5) records found, ask for more accurate search
            if [ "$count" -ge 5 ]
            then 
                echo "More then 5 records found. Please use more accurate search."
            fi
            ;;
        # search using the title
        -t)
            title_name="${@:2}"
            search_title $title_name
            count=$(python bibcount.py $search_title_result)
            echo "$count record(s) found"

            if [ "$count" == 0 ]
            then 
                echo "Oops!"                
            fi

            # if less then 5 records found, display the results
            if [ "$count" -lt 5 ]
            then 
                echo "--------------------------------------"
                End=$(($count - 1))
                for i in $(seq 0 $End); do
                    result=$(python getbib.py $search_title_result $i 2>&1)
                    echo "$result"
                done
            fi
            # if more then 5 (including 5) records found, ask for more accurate search
            if [ "$count" -ge 5 ]
            then 
                echo "More then 5 records found. Please use more accurate search."
            fi
            ;;
        # unknown parameters
        *)
            echo "Unknown parameter '$1'. Try [-t],[-e] instead. " 
            ;;
    esac
}

# quickly get the bibtex entry
bibit() {
    case "$1" in
        # search using the eprint
        -e)
            eprint_number="${@:2}"
            search_eprint $eprint_number
            result=$(python getbib.py $search_eprint_result 0 2>&1)
            echo "--------------------------------------"
            echo "$result"
            echo "--------------------------------------"
            # search for local .bib file and ask for saving         
            for i in $(find *.bib); do 
                echo "Local bib file found: $i" 
                while true; do
                read -p "Do you wish to save the bibtex to this file? [y/n]: " yn
                    case $yn in
                        [Yy]* ) echo -e "$result" >>"$i"; echo "Saved" ; break;;
                        [Nn]* ) break;;
                            * ) echo "Please answer yes or no.";;
                    esac
                done
            done
            ;;
        # search using the title
        -t)
            title_name="${@:2}"
            search_title $title_name
            count=$(python bibcount.py $search_title_result)
            result=$(python getbib.py $search_title_result 0 2>&1)
            echo "--------------------------------------"
            echo "$result"
            echo "--------------------------------------"
            # search for local .bib file and ask for saving         
            for i in $(find *.bib); do 
                echo "Local bib file found: $i" 
                while true; do
                read -p "Do you wish to save the bibtex to this file? [y/n]: " yn
                    case $yn in
                        [Yy]* ) echo -e "$result" >>"$i"; echo "Saved" ; break;;
                        [Nn]* ) break;;
                            * ) echo "Please answer yes or no.";;
                    esac
                done
            done
            ;;
        # unknown parameters
        *)
            echo "Unknown parameter '$1'. Try [-t],[-e] instead. " 
            ;;
    esac
}
