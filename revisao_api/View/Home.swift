//
//  Home.swift
//  revisao_api
//
//  Created by Victor Pizetta on 01/05/23.
//

import UIKit

final class Home: UIView {
    
    var addressInfo: Address?
    var cep: String?
    
    private lazy var verticalStack: UIStackView = {
        let stack  = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.contentMode = .center
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stack  = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.contentMode = .center
        stack.spacing = 8
        stack.axis = .horizontal
        return stack
    }()
    
    let zipcodeInput: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Digite o cep que deseja buscar"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        return button
    }()
    
    let zipcodeLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    
    let addressLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    
    let cityLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    
    let ufLabel: CustomLabel = {
        let label = CustomLabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startSearch() {
        let network = Network()
        guard let inputCep = zipcodeInput.text else {return}
        if inputCep != "" {
            network.get(cep: inputCep) { result in
                switch result {
                case let .success(data):
                    self.addressInfo = data
                    if let addressInfo = self.addressInfo {
                        DispatchQueue.main.async {
                            self.zipcodeLabel.text = " Cep Digitado: \(addressInfo.zipcode)"
                            self.addressLabel.text = " Endereço: \(addressInfo.address)"
                            self.cityLabel.text = " Cidade: \(addressInfo.city)"
                            self.ufLabel.text = " Estado: \(addressInfo.uf)"
                        }
                    } else {
                        self.alerts(setTitle: "Atenção!", setMessage: "Por favor digite um cep")
                    }
                case let .failure(error):
                    print(error)
                    DispatchQueue.main.async {
                        self.alerts(setTitle: "Atenção", setMessage: "O cep não e válido")
                    }
                }
            }
        }
    }
    
    func alerts(setTitle: String, setMessage: String) {
        let alert = UIAlertController(title: setTitle, message: setMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension Home: ViewCodable {
    func buildHierarchy() {
        horizontalStack.addArrangedSubview(zipcodeInput)
        horizontalStack.addArrangedSubview(searchButton)
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(zipcodeLabel)
        verticalStack.addArrangedSubview(addressLabel)
        verticalStack.addArrangedSubview(cityLabel)
        verticalStack.addArrangedSubview(ufLabel)
        addSubview(verticalStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalToConstant: 45),
            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            verticalStack.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func applyAdditionalChanges() {
        backgroundColor = .orange
    }
}
