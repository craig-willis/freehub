#!/usr/bin/perl


# Keep 
#   Most recent names, email, address, phone, zip, city, state, country
#   Most recent address
#   Most recent email
#   email_opt_out if true


# Downtown
# 1034891640 - 1034903333

# Campus
# 1034887003 - 1034903350

my $service_id = 1;
my $interest_id = 1;
my $visit_id = 1;
my $new_person_id = 8000;
my %newpeople;
my %name_id_map;

my %oldpeople;
my %old_id_map;
my %interests_map;
my %services_map;

open(SERVICES, ">services.out");
open(VISITS, ">visits.out");
open(PEOPLE, ">people.out");
open(INTERESTS, ">interests.out");

# Read the mysql dump files;
# people
read_people("downtown_urbana_tbp_people_freehub_to_2013-4-24.csv");
read_people("campus_shop_tbp_people_freehub_to_2013-04-24.csv");


while (<>)
{
  chomp($_);
  my ($split, $id, $first_name, $last_name, $staff, $email, 
     $email_opt_out, $phone, $postal_code, $street1, $street2, $city, 
     $state, $country, $yob, $created_at, $membership_expires_on, 
     $timestamp, $membership_start, $what_membership_type, $zip_code, 
     $volunteer_announcements, $interests_skills, 
     $membership_status, $consent, $shop_membership) = split /\t/, $_;

     print "split = \t\t\t$split\n";
     print "id = \t\t\t$id\n";
     print "first_name = \t\t\t$first_name\n";
     print "last_name = \t\t\t$last_name\n";
     print "email = \t\t\t$email\n";
     print "created_at = \t\t\t$created_at\n";
     print "membership_start = \t\t\t$membership_start\n";
     print "street1 = \t\t\t$street1\n";
 
     my @ids = parse_numeric($id);
     my @splits = parse_split($split, scalar(@ids));
     my @dates = parse_date($created_at, scalar(@ids));
     my @first_names = parse_string($first_name, scalar(@ids));
     my @last_names = parse_string($last_name, scalar(@ids));
     my @emails = parse_string($email, scalar(@ids));
     my @phones = parse_numeric($phone, scalar(@ids));
     my @street1s = parse_string($street1, scalar(@ids));
     my @street2s = parse_string($street2, scalar(@ids));
     my @cities = parse_string($city, scalar(@ids));
     my @states = parse_string($state, scalar(@ids));
     my @postal_codes = parse_numeric($postal_code, scalar(@ids));
     my @opt_outs = parse_boolean($email_opt_out, scalar(@ids));
     my @yobs = parse_numeric($yob, scalar(@ids));
     my @membership_starts = parse_date($membership_start, scalar(@ids));
     my @membership_ends = parse_date($membership_ends, scalar(@ids));
     my @membership_types = parse_string($membership_type, scalar(@ids));
     my @interests = parse_string($interests_skills, scalar(@ids));
     my @consents = parse_string($consent, scalar(@ids));

     
     my $idx = 0;
   
     # For each split, create a new person recordc
     # Tables: interests, people, services, visits, users
  
     my %best;
     my @newids;

     for $split (@splits) {
       for $x (@{$split}) { 
          my $oldid = $ids[$x-1];

          # membership data
          if ($ids[$x-1] < 10000) 
          {
             if ($membership_starts[$x-1] !~ /0000-00-00/) {
                do_interests($interests[$x-1], $new_person_id);

                my $tmp = $membership_types[$x-1];
                my $memtype= 'REGULAR';
                if ($tmp = /family/i) { $memtype = 'FAMILY' }
                if ($tmp = /regular/i) { $memtype = 'REGULAR' }
                if ($tmp = /student/i) { $memtype = 'STUDENT' }
                if ($tmp = /bike purchase/i) { $memtype = 'WBP' }
                if ($tmp = /equity/i) { $memtype = 'EQUITY' }
   
                if ($best{$new_person_id}{"date"} eq "" ) {
                 if ($first_names[$x-1] ne "") {  $best{$new_person_id}{"first_name"} = $first_names[$x-1]; }
                 if ($last_names[$x-1] ne "") {  $best{$new_person_id}{"last_name"} = $last_names[$x-1]; }
                 if ($emails[$x-1] ne "") {  $best{$new_person_id}{"email"} = $emails[$x-1]; }
                 if ($first_names[$x-1] ne "") {  $best{$new_person_id}{"first_name"} = $first_names[$x-1]; }
                 if ($last_names[$x-1] ne "") {  $best{$new_person_id}{"last_name"} = $last_names[$x-1]; }
                 if ($street1s[$x-1] ne "") {  $best{$new_person_id}{"street1"} = $street1s[$x-1]; }
                 if ($street2s[$x-1] ne "") {  $best{$new_person_id}{"street2"} = $street2s[$x-1]; }
                 if ($cities[$x-1] ne "") {  $best{$new_person_id}{"city"} = $cities[$x-1]; }
                 if ($states[$x-1] ne "") {  $best{$new_person_id}{"state"} = $states[$x-1]; }
                 if ($postal_codes[$x-1] ne "") {  $best{$new_person_id}{"postal_code"} = $postal_codes[$x-1]; }
                 if ($countries[$x-1] ne "") {  $best{$new_person_id}{"country"} = $countries[$x-1]; }
                 if ($emails[$x-1] ne "") {  $best{$new_person_id}{"email"} = $emails[$x-1]; }
                 if ($phones[$x-1] ne "") {  $best{$new_person_id}{"phone"} = $phones[$x-1]; }
                 if ($opt_outs[$x-1] ne "") {  $best{$new_person_id}{"opt_out"} = $opt_outs[$x-1]; }
                 if ($yobs[$x-1] ne "") {  $best{$new_person_id}{"yob"} = $yobs[$x-1]; }
                 if ($consents[$x-1] ne "") {  $best{$new_person_id}{"consent"} = $consents[$x-1]; }
               }

                # services
                # print id | start_date | end_date | paid | volunteered | service_type_id | person_id | created_at | updated_at | created_by_id | updated_by_id\n";
                
                if ($services{$new_person_id} < $membership_starts[$x-1]) { 
                   print SERVICES "0|" . $membership_starts[$x-1] . "|" . $membership_ends . "|1|0|". $memtype . "|" . $new_person_id . "|" . $membership_starts[$x-1] . "||729244041|729244041\n";
                   $services{$new_person_id} = $membership_starts[$x-1];
                }
             }
             #print "$idx, $x, m, " . $ids[$x-1] . ", " . $membership_dates[$x-1] .", "  . 
             #      $first_names[$x-1] . ", " . $last_names[$x-1] . ", " . $phones[$x-1] . ", " . $emails[$x-1] . ", " . $streets[$x-1] . "\n";



          } else { 

#CAW
print $x . ", " . $oldid . ", " . $dates[$x-1] . ", " . $new_person_id . "\n";

             if ($best{$new_person_id}{"date"} < $dates[$x-1]) {
                 if ($first_names[$x-1] ne "") {  $best{$new_person_id}{"first_name"} = $first_names[$x-1]; }
                 if ($last_names[$x-1] ne "") {  $best{$new_person_id}{"last_name"} = $last_names[$x-1]; }
                 if ($street1s[$x-1] ne "") {  $best{$new_person_id}{"street1"} = $street1s[$x-1]; }
                 if ($street2s[$x-1] ne "") {  $best{$new_person_id}{"street2"} = $street2s[$x-1]; }
                 if ($cities[$x-1] ne "") {  $best{$new_person_id}{"city"} = $cities[$x-1]; }
                 if ($states[$x-1] ne "") {  $best{$new_person_id}{"state"} = $states[$x-1]; }
                 if ($postal_codes[$x-1] ne "") {  $best{$new_person_id}{"postal_code"} = $postal_codes[$x-1]; }
                 if ($countries[$x-1] ne "") {  $best{$new_person_id}{"country"} = $countries[$x-1]; }
                 if ($emails[$x-1] ne "") {  $best{$new_person_id}{"email"} = $emails[$x-1]; }
                 if ($phones[$x-1] ne "") {  $best{$new_person_id}{"phone"} = $phones[$x-1]; }
                 if ($opt_outs[$x-1] ne "") {  $best{$new_person_id}{"opt_out"} = $opt_outs[$x-1]; }
                 if ($yobs[$x-1] ne "") {  $best{$new_person_id}{"yob"} = $yobs[$x-1]; }
             }

             # "PEOPLE id|first_name|last_name|full_name|street1|street2|city|state|postal_code|country|email|email_opt_out|
             #          phone|staff|created_at|updated_at|created_by_id|updated_by_id|organization_id|yob|hashed_password|accept_waiver";

          }
       }

       $old_id_map{$oldid}{$new_person_id};
       $people{$new_person_id}{$oldid} = 1;

       # each split is a new person
       push @newids, $new_person_id;
       $new_person_id++;
       $idx++;
     }
     for $id (@newids) {
        my $key = lc($best{$id}{"first_name"} . " " . $best{$id}{"last_name"}); 
        $name_id_map{$key} = $id;
        my $full_name = $best{$id}{"first_name"} . " " . $best{$id}{"last_name"} ; 
        my $consent = $best{$id}{"consent"} =~ /agree/i;
        print PEOPLE $id . "|". $best{$id}{"first_name"} . "|" . $best{$id}{"last_name"} . "|" . $full_name . "|" . 
                  $best{$id}{"street1"} . "|" . $best{$id}{"street2"} . "|" . $best{$id}{"city"} . "|" . $best{$id}{"state"} . "|" . 
                  $best{$id}{"postal_code"} . "|" . $best{$id}{"country"} . "|" . $best{$id}{"email"} . "|" . 
                  $best{$id}{"opt_out"} . "|" . $best{$id}{"phone"} . "|0|" . $best{$id}{"date"} . "|" . 
                  $best{$id}{"date"} . "|729244041|729244041|729244041|" . $best{$id}{"yob"} . "||$consent|||||\n";
     }
}

print PEOPLE "999|Dummy|User|Dummy User|123 Main St.||Urbana|IL||||||0|0000-00-00 00:00:00|0000-00-00 00:00:00|729244041|729244041|729244041|9999||0\n";

#interests
for $id (keys %interests_map) {
    print INTERESTS "0" . "|" . $interests_map{$id}{"BikeRepair"} . "|" . $interests_map{$id}{"DataEntry"} . "|" . $interests_map{$id}{"Sales"} . "|" . 
        $interests_map{$id}{"Publicity"} . "|" . $interests_map{$id}{"Teaching"} . "|" . $interests_map{$id}{"Office"} . "|" . 
        $interests_map{$id}{"Carpentry"} . "|" . $interests_map{$id}{"Sewing"} . "|" . $interests_map{$id}{"Vehicle"} . "|" . 
        $interests_map{$id}{"Grant"} . "|" . $interests_map{$id}{"Accounting"} . "|" . $interests_map{$id}{"Cleaning"} . "|" .  
        $interests_map{$id}{"EventPlanning"} . "|" . $interests_map{$id}{"WorkingWithChildren"} . "|" . $interests_map{$id}{"Website"} . "|" . 
        $interests_map{$id}{"Photography"} . "|" . $interests_map{$id}{"Electrician"} . "|" . $interests_map{$id}{"Legal"} . "|" . 
        $interests_map{$id}{"Newsletter"} . "|" . $interests_map{$id}{"Whatever"} . "|" . "$date||729244041|729244041|$id\n";
}

#  visits
my %oldvisits;
read_visits("../dump/bak/downtown_urbana_tbp_visits_to_2013-04-24.csv", 1);
read_visits("../dump/bak/campus_shop_tbp_visits_to_2013-04-24.csv", 0);

for $idx (keys %oldvisits) {
   my $key = $oldvisits{$idx}{"key"};
   my $person_id = $name_id_map{$key};
   if ($person_id eq "") { 
      print "Can't find person id for key $key\n";
      $person_id = 999;
    }
   my $arrived_at =  $oldvisits{$idx}{"arrived_at"};
   my $shop =  $oldvisits{$idx}{"shop"};
   my $volunteer =  $oldvisits{$idx}{"volunteer"};
   # id arrived_at created_at updated_at created_by updated_by person_id staff member shop
   print VISITS "0|" . $arrived_at . "|" . $volunteer . "|" . $arrived_at . "||729244041|729244041|" . $person_id . "|0|0|" . $shop . "\n";
}


sub read_people() {
   my ($file) = @_;
   open (P, $file);
   while (<P>) {
      chomp($_);
      my ($id, $first_name, $last_name, $staff, $email, $email_opt_out, $phone, $postal_code, 
          $street1, $street2, $city, $state, $postal_code, $country, $yob, $created_at, 
          $membership_expires_on) = split /,/, $_;

      $oldpeople{$id}{"first_name"} = $first_name;
      $oldpeople{$id}{"last_name"} = $last_name;
      $oldpeople{$id}{"staff"} = $staff;
      $oldpeople{$id}{"email"} = $email;
      $oldpeople{$id}{"email_opt_out"} = $email_opt_out;
      $oldpeople{$id}{"phone"} = $phone;
      $oldpeople{$id}{"postal_code"} = $postal_code;
      $oldpeople{$id}{"street1"} = $street1;
      $oldpeople{$id}{"street2"} = $street2;
      $oldpeople{$id}{"city"} = $city;
      $oldpeople{$id}{"state"} = $state;
      $oldpeople{$id}{"postal_code"} = $postal_code;
      $oldpeople{$id}{"country"} = $country;
      $oldpeople{$id}{"yob"} = $yob;
      $oldpeople{$id}{"created_at"} = $created_at;
      $oldpeople{$id}{"membership_expires_on"} = $membership_expires_on;
   }
   close(P);
}

sub read_visits() {
   my ($file, $shop) = @_;
   open (V, $file);
   while (<V>) {
      chomp($_);
      my ($first_name, $last_name, $email, $email_opt_out, $phone, $postal_code, $arrived_at, $staff, $member, $volunteer, $note) = split /,/, $_;
      # id, arrived_at, volunteer, updated_at, created_by_id, updated_by_id, person_id, staff, member, shop
      my $key = lc("$first_name $last_name");
      $oldvisits{$visit_id}{"key"} = $key; 
      $oldvisits{$visit_id}{"first_name"} = $first_name; 
      $oldvisits{$visit_id}{"last_name"} = $last_name; 
      $oldvisits{$visit_id}{"email"} = $email; 
      $oldvisits{$visit_id}{"arrived_at"} = $arrived_at; 
      $oldvisits{$visit_id}{"volunteer"} = $volunteer; 
      $oldvisits{$visit_id}{"shop"} = $shop; 
      $visit_id++;
   }
   close(V);
}


sub parse_split()
{
   my ($field, $size) = @_;
   my @parsed;
   if ($field =~ /\[/) {
      while($field =~ /\[([^\]]*)\]/g) {
         my $tmp = $1; 
         my @splits = split /,/, $tmp;
         push (@parsed, [@splits]);
      }
   } else {
      my @splits ;
      for ($i = 1; $i <= $size; $i++) {
         push(@splits, $i);
      }
      push (@parsed, [@splits]);
   }
   return @parsed;
}

sub parse_numeric()
{
   my ($field) = @_;
   my @parsed;
   
   if ($field =~ /^"{(.*)}"$/g) {
       $field  = $1;
       while($field =~ /([^,]*,|\s.*?$)/g) {
         my $tmp = $1; 
         $tmp =~ s/ //g;
         $tmp =~ s/,//g;
         $tmp =~ s/""""//g;
         push (@parsed, $tmp);
       }
   }
   else { 
      push @parsed, $field;
   }
   return @parsed;
}

sub parse_boolean()
{
   my ($field) = @_;
   my @parsed;
   
   if ($field =~ /^"{(.*)}"$/g) {
       $field  = $1;
       while($field =~ /([^,]*,|\s.*?$)/g) {
         my $tmp = $1; 
         $tmp =~ s/ //g;
         $tmp =~ s/,//g;
         $tmp =~ s/""""//g;
         if ($tmp eq "False" || $tmp eq "") {
            push (@parsed, 0);
         } else { 
            push (@parsed, 1);
         }
       }
   }
   else { 
      push @parsed, $field;
   }
   return @parsed;
}

#"{"""", """", {2011, 1, 15, 20, 37, 29}, {2011, 1, 15, 20, 38, 37}, {2011, 1, 15, 20, 39, 41}}"
#  """", """", {2011, 1, 15, 20, 37, 29}, {2011, 1, 15, 20, 38, 37}, {2011, 1, 15, 20, 39, 41}}

sub parse_date()
{
   my ($field) = @_;
   my @parsed;
   if ($field =~ /^"{(.*)}"$/) {
       $field  = $1;
       while($field =~ /("[^,]*,|{[^}]*})/g) {
         my $tmp = $1; 
         $tmp =~ s/ //g;
         $tmp =~ s/{//g;
         $tmp =~ s/}//g;
         $tmp =~ s/""""//g;
         if ($tmp =~ /,/) {
            my ($year, $month, $day, $hour, $min, $sec) = split /,/, $tmp;
            $tmp = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec);
            #'YYYY-MM-DD HH:MM:SS'
         } 
         push (@parsed, $tmp);
       }
   }
   else { 
      push @parsed, $field;
   }
   return @parsed;
}


sub parse_string()
{
   my ($field, $size) = @_;
   my @parsed;
   
   if ($field =~ /^"{(.*)}"$/g) {
       $field = $1;
       # ""Adam"", ""Jessica"", ""Adam""
       while($field =~ /""([^"]*)""(?:,|$)/g) {
          my $tmp = $1;
          $tmp =~ s/^ //g;
          $tmp =~ s/ $//g;
          push(@parsed, $tmp);
       }
   }
   else { 
      for ($i =0; $i < $size; $i++) {
         push @parsed, $field;
      }
   }
   return @parsed;
}


sub do_interests() 
{
   my ($field, $person) = @_;
 
   my $BikeRepair = $DataEntry = $Sales = $Publicity = $Accounting = 
      $Office = $Carpentry = $WorkingWithChildren = $Cleaning = 
      $Electrician = $EventPlanning = $Grant = $Fundraising = 
      $Legal = $Photography = $Newsletter = $Sales = $Sewing = 
      $Teaching = $Vehicle = $Photography = $Website = $Whatever =  0;

   if ($field =~ /repair/i) { $BikeRepair=1; } 
   if ($field =~ /data entry/i) { $DataEntry=1; } 
   if ($field =~ /sales/i) { $Sales=1; } 
   if ($field =~ /publicity/i) { $Publicity=1; } 
   if ($field =~ /promotion/i) { $Publicity=1; } 
   if ($field =~ /accounting/i) { $Accounting=1; } 
   if ($field =~ /administrative/i) { $Office=1; } 
   if ($field =~ /office/i) { $Office=1; } 
   if ($field =~ /carpentry/i) { $Carpentry=1; } 
   if ($field =~ /children/i) { $WorkingWithChildren=1; } 
   if ($field =~ /cleaning/i) { $Cleaning=1; } 
   if ($field =~ /organizing/i) { $Cleaning=1; } 
   if ($field =~ /electric/i) { $Electrician=1; } 
   if ($field =~ /event/i) { $Event=1; } 
   if ($field =~ /grant/i) { $Grant=1; } 
   if ($field =~ /fund/i) { $Grant=1; } 
   if ($field =~ /legal/i) { $Legal=1; } 
   if ($field =~ /photo/i) { $Photograpy=1; } 
   if ($field =~ /video/i) { $Photograpy=1; } 
   if ($field =~ /news/i) { $Newsletter=1; } 
   if ($field =~ /teach/i) { $Teaching=1; } 
   if ($field =~ /vehicle/i) { $Vehicle=1; } 
   if ($field =~ /trailer/i) { $Vehicle=1; } 
   if ($field =~ /website/i) { $Website=1; } 
   if ($field =~ /computer/i) { $Website=1; } 
   if ($field =~ /whatever/i) { $Whatever=1; } 

   # interests
   # BikeRepair | DataEntry | Sales | Publicity | Teaching | Office | Carpentry | Sewing
   # | Vehicle | Grant | Accounting | Cleaning | EventPlanning | WorkingWithChildren | Website
   # | Photography | Electrician | Legal | Newsletter | Whatever | created_at | updated_at
   # | created_by_id | updated_by_id | person_id

   if ($BikeRepair != 0) { $interests_map{$person}{"BikeRepair"} = $BikeRepair;} 
   if ($DataEntry != 0) { $interests_map{$person}{"DataEntry"} = $DataEntry; }
   if ($Sales != 0) { $interests_map{$person}{"Sales"} = $Sales; }
   if ($Publicity != 0) { $interests_map{$person}{"Publicity"} = $Publicity; }
   if ($Teaching != 0) { $interests_map{$person}{"Teaching"} = $Teaching; }
   if ($Office != 0) { $interests_map{$person}{"Office"} = $Office; }
   if ($Carpentry != 0) { $interests_map{$person}{"Carpentry"} = $Carpentry; }
   if ($Sewing != 0) { $interests_map{$person}{"Sewing"} = $Sewing;}
   if ($Vehicle != 0) { $interests_map{$person}{"Vehicle"} = $Vehicle;}
   if ($Grant != 0) { $interests_map{$person}{"Grant"} = $Grant;}
   if ($Accounting != 0) { $interests_map{$person}{"Accounting"} = $Accounting;}
   if ($Cleaning != 0) { $interests_map{$person}{"Cleaning"} = $Cleaning;}
   if ($EventPlanning != 0) { $interests_map{$person}{"EventPlanning"} = $EventPlanning;}
   if ($WorkingWithChildren != 0) { $interests_map{$person}{"WorkingWithChildren"} = $WorkingWithChildren;}
   if ($Website != 0) { $interests_map{$person}{"Website"} = $Website;}
   if ($Photography != 0) { $interests_map{$person}{"Photography"} = $Photography;}
   if ($Electrician != 0) { $interests_map{$person}{"Electrician"} = $Electrician;}
   if ($Legal != 0) { $interests_map{$person}{"Legal"} = $Legal;}
   if ($Newsletter != 0) { $interests_map{$person}{"Newsletter"} = $Newsletter;}
   if ($Whatever != 0) { $interests_map{$person}{"Whatever"} = $Whatever;}

   #print INTERESTS "0|$BikeRepair|$DataEntry|$Sales|$Publicity|$Teaching|" . 
   #      "$Office|$Carpentry|$Sewing|$Vehicle|$Grant|$Accounting|$Cleaning|$EventPlanning|" . 
   #      "$WorkingWithChildren|$Website|$Photography|$Electrician|$Legal|$Newsletter|$Whatever|" . 
   #      "$date||729244041|729244041|$person\n";
}

#"{1034890314, 1034890315, """"}"        
#"{""Adam"", ""Jessica"", ""Adam""}"     
# Brandt  
# FALSE   
# "{""albrandt0@gmail.com"", ""jrbrandt0@gmail.com"", ""albrandt0@gmail.com""}"   
# FALSE   
# "{3015244066, 3015248601, 3015244066}"  
# 61802   
# "{""2403 Sharlyn Drive"", ""2403 Sharlyn Drive"", """"}"                
# "{""Urbana"", ""Urbana"", """"}"        
# "{""IL"", ""IL"", """"}"        
# "{""USA"", ""USA"", """"}"     
# "{1985, 1985, """"}"    
# "{{2010, 8, 9, 0, 11, 16}, {2010, 8, 9, 0, 12, 20}, """"}" 
# "{"""", """", {2010, 8, 8, 19, 11, 0}}" 
# "{"""", """", False}"  
# "{"""", """", False}"

#"{1034898070, """", 1034894431, """", """", """", """", """"}"  
#Aaron   
#Amram   
#FALSE   
#aaron.amram@ncf.edu     
#"{True, True, False, False, False, False, False, False}"                
#"{61801, 61801, """", """", """", """", """", """"}"    
#"{""502 W Illinois St #2"", """", ""412 Illinois St"", """", """", """", """", """"}"           
#"{""Urbana"", """", ""Ur"", """", """", """", """", """"}"      
#"{""IL"", """", """", """", """", """", """", """"}"    
#"{""USA"", """", ""USA"", """", """", """", """", """"}"               
#"{{2012, 3, 23, 18, 5, 48}, """", {2011, 6, 22, 0, 40, 17}, """", """", """", """", """"}"      
#"{"""", """", {2012, 6, 21, 0, 0, 0}, """", """", """", """", """"}"   
#"{"""", {2012, 3, 23, 13, 5, 0}, """", {2013, 4, 11, 18, 46, 0}, {2013, 3, 7, 19, 47, 0}, {2013, 3, 5, 20, 44, 0}, {2012, 9, 11, 19, 17, 0}, {2011, 6, 21, 19, 43, 0}}" 
#"{"""", False, """", False, False, False, False, True}" 
#"{"""", False, """", False, False, False, False, False}"                                                   

