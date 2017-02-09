Customer.destroy_all
ServiceEngineer.destroy_all

customers = [[43.020869, -87.935931, "1011 S 18th St, Milwaukee, WI 53204, USA", "Adrienne Kautzer"],
 [42.796925, -88.614484, "6101-6499 US-12, Whitewater, WI 53190, USA", "Rory Sawayn"],
 [42.741963, -88.026751, "17640 Old Yorkville Rd, Union Grove, WI 53182, USA", "Tatum Leannon"],
 [43.237507, -87.9787, "398 Vernon Ave, Thiensville, WI 53092, USA", "Ross Mertz"],
 [43.060842, -88.403708, "600-622 Main St, Delafield, WI 53018, USA", "Webster Greenfelder"],
 [42.63307, -88.643714, "400-404 E Walworth Ave, Delavan, WI 53115, USA", "Jedidiah Barrows III"],
 [42.969354, -87.935931, "4100 S 20th St, Milwaukee, WI 53221, USA", "Kendall Greenholt"],
 [42.934456, -88.405374, "128 N Main St, North Prairie, WI 53153, USA", "Ms. Shawna Sawayn"],
 [43.31389, -88.34194, "3384 Lake Dr, Hartford, WI 53027, USA", "Gerry Dare"],
 [43.108972, -88.170756, "20711 Lisbon Rd, Menomonee Falls, WI 53051, USA", "Sofia Reichert"],
 [43.076645, -88.159125, "Mitchell Park Dr, Brookfield, WI 53045, USA", "Ms. Hollis Mitchell"],
 [42.688074, -88.051473, "910 N 10th Ave, Union Grove, WI 53182, USA", "Miss Bernard Crona"],
 [43.06774, -87.890727, "1500 E Park Pl, Milwaukee, WI 53211, USA", "Lavern Carter"],
 [43.38417, -88.46056, "5288 Co Rd P, Rubicon, WI 53078, USA", "Mossie Boehm"],
 [42.925285, -88.692603, "2361 Co Rd D, Fort Atkinson, WI 53538, USA", "Mrs. Justen Sanford"],
 [43.033207, -87.97513, "239 N Story Pkwy, Milwaukee, WI 53208, USA", "Dr. Adolph Hermiston"],
 [43.191117, -88.343707, "O Neil Rd, Merton, WI, USA", "Derek Herman"],
 [42.763072, -88.214256, "111 S River St, Waterford, WI 53185, USA", "Gene Moen"]]

customers.each do |customer|
  Customer.create(name: customer[3], latitude: customer[0], longitude: customer[1], address: customer[2] )
end

service_engineers = [[43.228617, -88.110369, "W162N11634 Park Ave, Germantown, WI 53022, USA", "Miss Rupert Kuhic"],
 [42.985486, -88.02408, "3253 S 89th St, Milwaukee, WI 53227, USA", "Dayana Considine"],
 [43.056548, -87.986969, "2028 N 60th St, Milwaukee, WI 53208, USA", "Terrence Kshlerin Jr."],
 [43.004818, -88.077682, "13175 W Graham St, New Berlin, WI 53151, USA", "Mariam Beier"],
 [43.317779, -88.378986, "20 W Sumner St, Hartford, WI 53027, USA", "Ansel Towne"],
 [42.726125, -88.5426, "N6444 US-12, Elkhorn, WI 53121, USA", "Orlo Donnelly"],
 [42.505297, -88.070639, "21727 121st St, Bristol, WI 53104, USA", "Mr. General Schoen"],
 [43.151119, -88.246204, "2513 Howard Ln, Sussex, WI 53089, USA", "Judah Crona"],
 [42.800851, -88.012584, "7625 W 5 Mile Rd, Franksville, WI 53126, USA", "Torrance Hodkiewicz"]]

service_engineers.each do |service_engineer|
  ServiceEngineer.create(name: service_engineer[3], latitude: service_engineer[0], longitude: service_engineer[1], location: service_engineer[2])
end
