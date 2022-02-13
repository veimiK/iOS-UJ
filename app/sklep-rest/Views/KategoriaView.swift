//
//  KategoriaView.swift
//  sklep-rest
//
//  reated by user208780 on 2/3/22.
//

import SwiftUI
import CoreData
struct KategoriaView: View {
    let persistance = PersistenceService.share
    var kategorie = [Kategoria]()
    init(){
        kategorie = persistance.loadKategorie()
    }
    var body: some View {
        NavigationView {
        List {
            ForEach(kategorie) { kategoria in
                HStack{
                    NavigationLink(kategoria.title!, destination: ProductView(kategoria: kategoria))
                }
            }
        }
        }
    }
}
struct KategoriaView_Previews: PreviewProvider {
    static var previews: some View {
        KategoriaView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}

