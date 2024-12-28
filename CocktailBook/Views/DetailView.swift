import SwiftUI

struct DetailView: View {
    let cocktail: Cocktail
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(cocktail.name)
                .font(.largeTitle)
                .bold()
            HStack {
                Image(systemName: "clock")
                Text("Preparation Time: \(cocktail.preparationMinutes) minutes")
            }
            .font(.subheadline)
            Image(cocktail.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Text("Description")
                .font(.headline)

            Text(cocktail.longDescription)
            
            Text("Ingredients")
                .font(.headline)

            ForEach(cocktail.ingredients, id: \.self) { ingredient in
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text(ingredient)
                    
                }
            }
            
            Spacer()
           
        }
        .padding()
        .navigationBarTitle(Text(cocktail.name), displayMode: .inline)
        .navigationBarItems(
                    trailing: Button(action: {
                        viewModel.toggleFavorite(for: cocktail)
                    }) {
                        Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(cocktail.isFavorite ? .red : .gray)
                    }
                )
            }
        }
