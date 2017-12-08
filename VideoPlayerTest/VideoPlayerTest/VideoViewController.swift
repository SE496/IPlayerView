/*
 MIT License
 
 Copyright (c) 2017 Sarim Ashfaq
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import Player

class VideoViewController: UITableViewController {
    
    var scrollViewScrolled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    // MARK: - To play video of current visible cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        if !scrollViewScrolled {
            //to play video in first cell
            if indexPath.row == 0 {
                cell.playVideo("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
                scrollViewScrolled = true
            }
        }
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewScrolled {
            for item in tableView.indexPathsForVisibleRows!{
                if tableView.bounds.contains(tableView.rectForRow(at: item)){
                    let cell = tableView.cellForRow(at: item) as! PlayerCell
                    cell.playVideo("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
                } else {
                    if let cell = tableView.cellForRow(at: item) as? PlayerCell{
                        cell.stopVideo()
                    }
                }
            }
        }
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for item in tableView.indexPathsForVisibleRows!{
            if tableView.bounds.contains(tableView.rectForRow(at: item)){
                let cell = tableView.cellForRow(at: item) as! PlayerCell
                cell.playVideo("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            } else {
                if let cell = tableView.cellForRow(at: item) as? PlayerCell{
                    cell.stopVideo()
                }
            }
        }
    }
}


class PlayerCell: UITableViewCell {
    @IBOutlet weak var playerView: IPlayerView!
    
    override func awakeFromNib() {
        
    }
    
    func playVideo(_ url: String){
        playerView.playVideo(videoURL: url)
    }
    
    func stopVideo(){
        playerView.stopVideo()
    }
}

