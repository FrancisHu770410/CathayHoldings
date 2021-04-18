//
//  CHMainViewController.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/17.
//

import UIKit

class CHMainViewController: UIViewController {
    
    @IBOutlet weak var m_tvData: UITableView!
    @IBOutlet weak var m_vNavigation: UIView!
    @IBOutlet weak var m_lbSmallTitle: UILabel!
    @IBOutlet weak var m_lcTableViewY: NSLayoutConstraint!
    @IBOutlet weak var m_lcHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet var m_pgView: UIPanGestureRecognizer!
    
    private let m_aivLoading = UIActivityIndicatorView(style: .medium)
    
    private var m_cgStart: CGFloat = 0.0
    private let m_cgMax: CGFloat = 264.0
    
    private let m_vmMain: CHMainViewModel = CHMainViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        registerCell()
        settingLoading()
        bindingModel()
    }
    
    private func bindingModel() {
        m_aivLoading.bind(m_vmMain)
        m_tvData.bind(m_vmMain)
        m_vmMain.inquiryData()
    }
    
    private func registerCell() {
        m_tvData.register(UINib(nibName: "CHMainViewCell", bundle: nil),
                          forCellReuseIdentifier: "CHMainViewCellIdentifier")
    }
    
    private func settingLoading() {
        m_aivLoading.color = .darkGray
        m_aivLoading.hidesWhenStopped = true
        m_tvData.tableFooterView = m_aivLoading
    }
    
    private func gestureBeginOf(y: CGFloat) {
        m_cgStart = y
    }
    
    private func gestureModify(_ modify: CGFloat, y: CGFloat) {
        if m_tvData.contentOffset.y == 0 {
            let newY = m_lcTableViewY.constant + modify
            animateNavigation(with: newY)
        }
        
        if m_tvData.contentOffset.y != 0 || m_lcTableViewY.constant == m_lcHeaderViewHeight.constant {
            let cgTableViewY = m_tvData.contentOffset.y - modify
            scrollToOffset(y: cgTableViewY)
        }
        
        gestureBeginOf(y: y)
    }
    
    private func animateNavigation(with newY: CGFloat) {
        
        m_lcTableViewY.constant = valueIn(newY,
                                          min: m_lcHeaderViewHeight.constant,
                                          max: m_cgMax)
        
        let alpha = regular(m_lcTableViewY.constant,
                            min: m_lcHeaderViewHeight.constant,
                            max: m_cgMax)
        m_vNavigation.alpha = alpha
        m_lbSmallTitle.alpha = 1.0 - alpha
    }
    
    private func scrollToOffset(y cgTableViewY: CGFloat) {
        let contentOffsetY = valueIn(cgTableViewY, min: 0, max: m_tvData.contentSize.height - m_tvData.frame.size.height)
        
        m_tvData.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: false)
    }
    
    private func gestureEnd() {
        animateToResult()
        gestureCheckStatus()
    }
    
    private func animateToResult() {
        
        let showSmall = m_lbSmallTitle.alpha > 0.5
        let constant = showSmall ? m_lcHeaderViewHeight.constant : m_cgMax
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.calculationModeLinear]) { [unowned self] in
            
            m_lcTableViewY.constant = constant
            m_vNavigation.alpha = showSmall ? 0.0 : 1.0
            m_lbSmallTitle.alpha = showSmall ? 1.0 : 0.0
            view.layoutIfNeeded()
            
        } completion: { [unowned self] (complete) in
            m_lcTableViewY.constant = constant
            m_vNavigation.alpha = showSmall ? 0.0 : 1.0
            m_lbSmallTitle.alpha = showSmall ? 1.0 : 0.0
        }
    }
    
    private func gestureCheckStatus() {
        m_tvData.isScrollEnabled = m_tvData.contentOffset.y > m_tvData.frame.size.height
    }

    @IBAction func pan(gesture: UIPanGestureRecognizer) {
        let y = gesture.location(in: view).y
        
        switch gesture.state {
        case .began:
            gestureBeginOf(y: y)
            break
        case .changed:
            let modifyY = y - m_cgStart
            gestureModify(modifyY, y: y)
            break
        case .ended:
            gestureEnd()
            break
        default:
            break
        }
    }
}

extension CHMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            m_vmMain.inquiryData()
        }
        
        gestureCheckStatus()
    }
    
}

extension CHMainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_vmMain.aryViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CHMainViewCellIdentifier") as? CHMainViewCell else {
            return UITableViewCell()
        }
        cell.configure(m_vmMain.aryViewModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_vmMain.aryViewModel[indexPath.row].onClick()
    }
}
